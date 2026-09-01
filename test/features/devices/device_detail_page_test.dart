import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/core/realtime/ws_client.dart';
import 'package:orqestra_flutter/features/auth/auth_controller.dart';
import 'package:orqestra_flutter/features/devices/device_detail_page.dart';
import 'package:orqestra_flutter/features/devices/device_models.dart';
import 'package:orqestra_flutter/features/devices/device_providers.dart';
import 'package:orqestra_flutter/features/devices/device_repository.dart';

void main() {
  testWidgets(
    'optimistic state remains after detail page is removed and reopened',
    (tester) async {
      final command = Completer<void>();
      final events = StreamController<DeviceEvent>.broadcast();
      final repository = _FakeDeviceRepository(command.future);
      final container = ProviderContainer(
        overrides: [
          activeUserIdProvider.overrideWithValue('user-1'),
          deviceRepositoryProvider.overrideWithValue(repository),
          deviceEventsProvider.overrideWithValue(events.stream),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await events.close();
      });

      await tester.pumpWidget(_app(container));
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpWidget(_app(container));
      await tester.pump();
      await tester.pump();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      command.complete();
    },
  );
}

Widget _app(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: DeviceDetailPage(deviceId: 'device-1')),
  );
}

class _FakeDeviceRepository implements DeviceRepository {
  _FakeDeviceRepository(this.command);

  final Future<void> command;

  @override
  Future<List<Device>> myDevices() async => const [
    Device(
      id: 'device-1',
      name: 'Lamp',
      productId: 'product-1',
      status: 'ONLINE',
      capabilities: [
        Capability(
          id: 'power-id',
          key: 'power',
          name: 'Power',
          type: 'boolean',
          mode: 'read_write',
        ),
      ],
    ),
  ];

  @override
  Future<DeviceState> deviceState(String deviceId) async => {'power': false};

  @override
  Future<void> sendCommand(
    String deviceId, {
    required String capability,
    required dynamic value,
  }) => command;

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
