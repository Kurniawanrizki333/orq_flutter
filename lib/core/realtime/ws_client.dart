import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../network/endpoints.dart';

/// Backend wire shape from `realtime.Message`.
class DeviceEvent {
  DeviceEvent(this.type, this.deviceId, this.data);

  factory DeviceEvent.fromJson(String raw) {
    final message = jsonDecode(raw) as Map<String, dynamic>;
    return DeviceEvent(
      message['type'] as String,
      message['device_id'] as String,
      Map<String, dynamic>.from(message['data'] as Map),
    );
  }

  final String type;
  final String deviceId;
  final Map<String, dynamic> data;
}

typedef WsConnector = WsConnection Function(Uri uri);

/// Resolved lazily on every (re)connect so a socket that drops after a JWT
/// refresh reconnects with the *current* access token, not the one captured
/// at first connect. Reusing a stale token here is what froze live status:
/// the upgrade 401s, the reconnect loop retries the same dead token forever,
/// and the device is stuck on whatever the last REST snapshot said.
typedef WsTokenProvider = Future<String?> Function();

class WsConnection {
  const WsConnection({required this.stream, required this.close});

  final Stream<dynamic> stream;
  final FutureOr<void> Function() close;
}

class WsClient {
  WsClient({WsConnector? connector, List<Duration>? reconnectDelays})
    : _connector = connector ?? _connect,
      _reconnectDelays =
          reconnectDelays ??
          const [
            Duration(seconds: 1),
            Duration(seconds: 2),
            Duration(seconds: 5),
            Duration(seconds: 10),
            Duration(seconds: 30),
          ];

  final WsConnector _connector;
  final List<Duration> _reconnectDelays;

  WsConnection? _connection;
  StreamSubscription<dynamic>? _subscription;
  StreamController<DeviceEvent>? _controller;
  Timer? _reconnectTimer;
  WsTokenProvider? _tokenProvider;
  int _generation = 0;
  int _reconnectAttempt = 0;

  Stream<DeviceEvent> connect(WsTokenProvider tokenProvider) {
    final existing = _controller;
    if (existing != null && !existing.isClosed) {
      // Same live session: keep the shared stream, but adopt the latest
      // provider so future reconnects read the current token.
      _tokenProvider = tokenProvider;
      return existing.stream;
    }

    disconnect();
    _tokenProvider = tokenProvider;
    final controller = StreamController<DeviceEvent>.broadcast();
    _controller = controller;
    _open(++_generation);
    return controller.stream;
  }

  Future<void> _open(int generation) async {
    if (generation != _generation || _tokenProvider == null) {
      return;
    }

    final token = await _tokenProvider!();
    if (generation != _generation) return;
    if (token == null) {
      _scheduleReconnect(generation);
      return;
    }

    final connection = _connector(Uri.parse(Endpoints.ws(token)));
    _connection = connection;
    _subscription = connection.stream.listen(
      (raw) {
        if (generation != _generation || _controller?.isClosed != false) {
          return;
        }
        _reconnectAttempt = 0;
        try {
          _controller!.add(DeviceEvent.fromJson(raw as String));
        } catch (_) {
          // Ignore malformed frames without killing the live connection.
        }
      },
      onError: (_) => _scheduleReconnect(generation),
      onDone: () => _scheduleReconnect(generation),
    );
  }

  void _scheduleReconnect(int generation) {
    if (generation != _generation ||
        _tokenProvider == null ||
        _reconnectTimer != null) {
      return;
    }

    _subscription?.cancel();
    _subscription = null;
    _connection = null;
    final index = _reconnectAttempt < _reconnectDelays.length
        ? _reconnectAttempt
        : _reconnectDelays.length - 1;
    _reconnectAttempt++;
    _reconnectTimer = Timer(_reconnectDelays[index], () {
      _reconnectTimer = null;
      if (generation != _generation || _tokenProvider == null) {
        return;
      }
      _open(++_generation);
    });
  }

  void disconnect() {
    _generation++;
    _tokenProvider = null;
    _reconnectAttempt = 0;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _subscription?.cancel();
    _subscription = null;
    final connection = _connection;
    _connection = null;
    if (connection != null) unawaited(Future.sync(connection.close));
    _controller?.close();
    _controller = null;
  }

  static WsConnection _connect(Uri uri) {
    final channel = WebSocketChannel.connect(uri);
    return WsConnection(stream: channel.stream, close: channel.sink.close);
  }
}
