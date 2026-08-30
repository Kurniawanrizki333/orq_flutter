import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../network/endpoints.dart';

/// One message per device-state push: `{"device_id": "...", "state": {...}}`.
/// ponytail: exact wire shape unconfirmed (backend not built) — adjust the
/// `device_id`/`state` keys here once /iot/v1/ws ships for real.
class DeviceStateEvent {
  DeviceStateEvent(this.deviceId, this.state);
  final String deviceId;
  final Map<String, dynamic> state;
}

class WsClient {
  WebSocketChannel? _channel;
  StreamController<DeviceStateEvent>? _controller;

  Stream<DeviceStateEvent> connect(String token) {
    disconnect();
    final channel = WebSocketChannel.connect(Uri.parse(Endpoints.ws(token)));
    _channel = channel;
    final controller = StreamController<DeviceStateEvent>.broadcast();
    _controller = controller;

    channel.stream.listen(
      (raw) {
        try {
          final msg = jsonDecode(raw as String) as Map<String, dynamic>;
          final deviceId = msg['device_id'] as String?;
          final state = msg['state'] as Map<String, dynamic>?;
          if (deviceId != null && state != null) controller.add(DeviceStateEvent(deviceId, state));
        } catch (_) {
          // ignore malformed frames
        }
      },
      onError: (_) => controller.close(),
      onDone: () => controller.close(),
    );

    return controller.stream;
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _controller?.close();
    _controller = null;
  }
}
