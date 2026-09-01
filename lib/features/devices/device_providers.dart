import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/realtime/ws_client.dart';
import '../auth/auth_controller.dart';
import 'device_models.dart';
import 'device_repository.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository(ref.read(apiClientProvider));
});

final _wsClientProvider = Provider<WsClient>((ref) {
  final client = WsClient();
  ref.onDispose(client.disconnect);
  return client;
});

/// Shared connection for list and every open/cached device state controller.
final deviceEventsProvider = Provider<Stream<DeviceEvent>>((ref) {
  final userId = ref.watch(activeUserIdProvider);
  final client = ref.read(_wsClientProvider);
  if (userId == null) {
    client.disconnect();
    return const Stream<DeviceEvent>.empty();
  }

  final tokenStorage = ref.read(apiClientProvider).tokenStorage;
  return client.connect(() => tokenStorage.accessToken);
});

final myDevicesProvider =
    AsyncNotifierProvider<MyDevicesController, List<Device>>(
      MyDevicesController.new,
    );

class MyDevicesController extends AsyncNotifier<List<Device>> {
  StreamSubscription<DeviceEvent>? _events;
  final Map<String, String> _statusPatches = {};

  @override
  Future<List<Device>> build() async {
    final userId = ref.watch(activeUserIdProvider);
    await _events?.cancel();
    _events = null;
    _statusPatches.clear();
    ref.onDispose(() => _events?.cancel());
    if (userId == null) return [];

    _events = ref.watch(deviceEventsProvider).listen(_onEvent);
    final devices = await ref.read(deviceRepositoryProvider).myDevices();
    return [
      for (final device in devices)
        if (_statusPatches[device.id] case final status?)
          device.copyWith(status: status)
        else
          device,
    ];
  }

  void _onEvent(DeviceEvent event) {
    final status = event.type == 'device.status'
        ? event.data['status'] as String?
        : event.type == 'device.state' || event.type == 'device.telemetry'
        ? 'ONLINE'
        : null;
    if (status == null) return;

    _statusPatches[event.deviceId] = status;
    final devices = state.value;
    if (devices == null) return;
    state = AsyncData([
      for (final device in devices)
        if (device.id == event.deviceId)
          device.copyWith(status: status)
        else
          device,
    ]);
  }
}

final deviceStateProvider =
    AsyncNotifierProvider.family<DeviceStateController, DeviceState, String>(
      DeviceStateController.new,
    );

class DeviceStateController extends AsyncNotifier<DeviceState> {
  DeviceStateController(this.deviceId);

  final String deviceId;
  final DeviceState _canonical = {};
  final DeviceState _initialEventPatches = {};
  final Map<String, List<_PendingCommand>> _pending = {};
  StreamSubscription<DeviceEvent>? _events;
  int _nextOperationId = 0;

  @override
  Future<DeviceState> build() async {
    final userId = ref.watch(activeUserIdProvider);
    await _events?.cancel();
    _events = null;
    _canonical.clear();
    _initialEventPatches.clear();
    _pending.clear();
    ref.onDispose(() => _events?.cancel());
    if (userId == null) return {};

    _events = ref.watch(deviceEventsProvider).listen(_onEvent);
    final snapshot = await ref
        .read(deviceRepositoryProvider)
        .deviceState(deviceId);
    _canonical.addAll(snapshot);
    _canonical.addAll(_initialEventPatches);
    return _effectiveState();
  }

  Future<void> setCapability(String capability, dynamic value) async {
    final operation = _PendingCommand(++_nextOperationId, value);
    (_pending[capability] ??= []).add(operation);
    _emit();

    try {
      await ref
          .read(deviceRepositoryProvider)
          .sendCommand(deviceId, capability: capability, value: value);
      final operations = _pending[capability];
      final authoritativeEventDidNotSupersede =
          operations?.remove(operation) ?? false;
      if (authoritativeEventDidNotSupersede) {
        _canonical[capability] = value;
      }
      if (operations?.isEmpty ?? false) _pending.remove(capability);
      _emit();
    } catch (_) {
      final operations = _pending[capability];
      operations?.removeWhere((item) => item.id == operation.id);
      if (operations?.isEmpty ?? false) _pending.remove(capability);
      _emit();
      rethrow;
    }
  }

  bool isPending(String capability) =>
      _pending[capability]?.isNotEmpty ?? false;

  void _onEvent(DeviceEvent event) {
    if (event.deviceId != deviceId ||
        (event.type != 'device.state' && event.type != 'device.telemetry')) {
      return;
    }

    _initialEventPatches.addAll(event.data);
    _canonical.addAll(event.data);
    for (final entry in event.data.entries) {
      final operations = _pending[entry.key];
      if (operations == null) continue;
      final matchingIndex = operations.indexWhere(
        (item) => item.value == entry.value,
      );
      if (matchingIndex < 0) {
        _pending.remove(entry.key);
      } else {
        operations.removeRange(0, matchingIndex + 1);
        if (operations.isEmpty) _pending.remove(entry.key);
      }
    }
    if (state.hasValue) _emit();
  }

  DeviceState _effectiveState() {
    return {
      ..._canonical,
      for (final entry in _pending.entries) entry.key: entry.value.last.value,
    };
  }

  void _emit() {
    if (state.hasValue) state = AsyncData(_effectiveState());
  }
}

class _PendingCommand {
  const _PendingCommand(this.id, this.value);

  final int id;
  final dynamic value;
}
