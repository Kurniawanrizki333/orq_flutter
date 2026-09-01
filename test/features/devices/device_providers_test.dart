import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/core/realtime/ws_client.dart';
import 'package:orqestra_flutter/features/auth/auth_controller.dart';
import 'package:orqestra_flutter/features/devices/device_models.dart';
import 'package:orqestra_flutter/features/devices/device_providers.dart';
import 'package:orqestra_flutter/features/devices/device_repository.dart';

void main() {
  test(
    'WebSocket patch received during REST load wins over stale snapshot',
    () async {
      final snapshot = Completer<DeviceState>();
      final events = StreamController<DeviceEvent>.broadcast();
      final container = _container(
        repository: _FakeDeviceRepository(state: (_) => snapshot.future),
        events: events.stream,
      );
      addTearDown(() async {
        container.dispose();
        await events.close();
      });

      final loading = container.read(deviceStateProvider('device-1').future);
      await Future<void>.delayed(Duration.zero);
      events.add(DeviceEvent('device.state', 'device-1', {'power': true}));
      await Future<void>.delayed(Duration.zero);
      snapshot.complete({'power': false, 'brightness': 25});

      expect(await loading, {'power': true, 'brightness': 25});
    },
  );

  test(
    'optimistic command survives listener removal until authoritative echo',
    () async {
      final command = Completer<void>();
      final events = StreamController<DeviceEvent>.broadcast();
      final container = _container(
        repository: _FakeDeviceRepository(
          state: (_) async => {'power': false},
          command: (_, _, _) => command.future,
        ),
        events: events.stream,
      );
      addTearDown(() async {
        container.dispose();
        await events.close();
      });

      await container.read(deviceStateProvider('device-1').future);
      final subscription = container.listen(
        deviceStateProvider('device-1'),
        (_, _) {},
      );
      final mutation = container
          .read(deviceStateProvider('device-1').notifier)
          .setCapability('power', true);
      expect(
        container
            .read(deviceStateProvider('device-1').notifier)
            .isPending('power'),
        isTrue,
      );

      expect(container.read(deviceStateProvider('device-1')).value, {
        'power': true,
      });
      subscription.close();
      expect(container.read(deviceStateProvider('device-1')).value, {
        'power': true,
      });

      command.complete();
      await mutation;
      expect(
        container
            .read(deviceStateProvider('device-1').notifier)
            .isPending('power'),
        isFalse,
      );
      expect(container.read(deviceStateProvider('device-1')).value, {
        'power': true,
      });

      events.add(DeviceEvent('device.state', 'device-1', {'power': true}));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(deviceStateProvider('device-1')).value, {
        'power': true,
      });
    },
  );

  test('failed command rolls back only its own optimistic operation', () async {
    final commands = <Completer<void>>[];
    final events = StreamController<DeviceEvent>.broadcast();
    final container = _container(
      repository: _FakeDeviceRepository(
        state: (_) async => {'power': false},
        command: (_, _, _) {
          final command = Completer<void>();
          commands.add(command);
          return command.future;
        },
      ),
      events: events.stream,
    );
    addTearDown(() async {
      container.dispose();
      await events.close();
    });

    await container.read(deviceStateProvider('device-1').future);
    final controller = container.read(deviceStateProvider('device-1').notifier);
    final first = controller.setCapability('power', true);
    final second = controller.setCapability('power', false);
    expect(container.read(deviceStateProvider('device-1')).value, {
      'power': false,
    });

    commands.first.completeError(StateError('publish failed'));
    await expectLater(first, throwsStateError);
    expect(container.read(deviceStateProvider('device-1')).value, {
      'power': false,
    });

    commands.last.complete();
    await second;
    events.add(DeviceEvent('device.state', 'device-1', {'power': true}));
    await Future<void>.delayed(Duration.zero);
    expect(container.read(deviceStateProvider('device-1')).value, {
      'power': true,
    });

    events.add(DeviceEvent('device.state', 'device-1', {'power': false}));
    await Future<void>.delayed(Duration.zero);
    expect(container.read(deviceStateProvider('device-1')).value, {
      'power': false,
    });
  });

  test(
    'stale HTTP completion cannot overwrite authoritative WS mismatch',
    () async {
      final command = Completer<void>();
      final events = StreamController<DeviceEvent>.broadcast();
      final container = _container(
        repository: _FakeDeviceRepository(
          state: (_) async => {'power': false},
          command: (_, _, _) => command.future,
        ),
        events: events.stream,
      );
      addTearDown(() async {
        container.dispose();
        await events.close();
      });

      await container.read(deviceStateProvider('device-1').future);
      final mutation = container
          .read(deviceStateProvider('device-1').notifier)
          .setCapability('power', true);
      events.add(DeviceEvent('device.state', 'device-1', {'power': false}));
      await Future<void>.delayed(Duration.zero);
      command.complete();
      await mutation;

      expect(container.read(deviceStateProvider('device-1')).value, {
        'power': false,
      });
    },
  );

  test('device list applies status received while REST is loading', () async {
    final snapshot = Completer<List<Device>>();
    final events = StreamController<DeviceEvent>.broadcast();
    final container = _container(
      repository: _FakeDeviceRepository(devices: () => snapshot.future),
      events: events.stream,
    );
    addTearDown(() async {
      container.dispose();
      await events.close();
    });

    final loading = container.read(myDevicesProvider.future);
    await Future<void>.delayed(Duration.zero);
    events.add(DeviceEvent('device.status', 'device-1', {'status': 'ONLINE'}));
    await Future<void>.delayed(Duration.zero);
    snapshot.complete([_device(status: 'OFFLINE')]);

    expect((await loading).single.status, 'ONLINE');
  });
}

ProviderContainer _container({
  required _FakeDeviceRepository repository,
  required Stream<DeviceEvent> events,
}) {
  return ProviderContainer(
    overrides: [
      activeUserIdProvider.overrideWithValue('user-1'),
      deviceRepositoryProvider.overrideWithValue(repository),
      deviceEventsProvider.overrideWithValue(events),
    ],
  );
}

Device _device({required String status}) => Device(
  id: 'device-1',
  name: 'Lamp',
  productId: 'product-1',
  status: status,
);

class _FakeDeviceRepository implements DeviceRepository {
  _FakeDeviceRepository({
    Future<DeviceState> Function(String)? state,
    Future<void> Function(String, String, dynamic)? command,
    Future<List<Device>> Function()? devices,
  }) : _state = state ?? ((_) async => {}),
       _command = command ?? ((_, _, _) async {}),
       _devices = devices ?? (() async => []);

  final Future<DeviceState> Function(String) _state;
  final Future<void> Function(String, String, dynamic) _command;
  final Future<List<Device>> Function() _devices;

  @override
  Future<DeviceState> deviceState(String deviceId) => _state(deviceId);

  @override
  Future<void> sendCommand(
    String deviceId, {
    required String capability,
    required dynamic value,
  }) => _command(deviceId, capability, value);

  @override
  Future<List<Device>> myDevices() => _devices();

  @override
  Future<Device> claim({
    required String deviceCode,
    required String pairingToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ClaimPreview> claimPreview({
    required String deviceCode,
    required String pairingToken,
  }) {
    throw UnimplementedError();
  }
}
