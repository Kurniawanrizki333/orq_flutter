import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/realtime/ws_client.dart';
import '../auth/auth_controller.dart';
import 'device_models.dart';
import 'device_repository.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository(ref.read(apiClientProvider));
});

final myDevicesProvider = FutureProvider<List<Device>>((ref) {
  return ref.read(deviceRepositoryProvider).myDevices();
});

final _wsClientProvider = Provider<WsClient>((ref) {
  final client = WsClient();
  ref.onDispose(client.disconnect);
  return client;
});

/// Single shared WS connection (broadcast stream), fanned out per-device below.
/// riverpod 3.x dropped the `.stream` modifier — expose the raw broadcast
/// Stream directly instead of wrapping it in StreamProvider.
final _deviceEventsProvider = Provider<Stream<DeviceStateEvent>>((ref) {
  return ref.read(apiClientProvider).tokenStorage.accessToken.asStream().asyncExpand((token) {
    if (token == null) return const Stream.empty();
    return ref.read(_wsClientProvider).connect(token);
  });
});

/// REST snapshot on subscribe, then live-merged with WS pushes for [deviceId].
final deviceStateProvider = StreamProvider.family<DeviceState, String>((ref, deviceId) async* {
  final snapshot = await ref.read(deviceRepositoryProvider).deviceState(deviceId);
  var state = snapshot;
  yield state;

  await for (final event in ref.watch(_deviceEventsProvider)) {
    if (event.deviceId != deviceId) continue;
    state = {...state, ...event.state};
    yield state;
  }
});
