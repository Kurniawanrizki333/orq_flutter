import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/core/realtime/ws_client.dart';

void main() {
  test('parses backend device event data', () {
    final event = DeviceEvent.fromJson(
      '{"type":"device.state","device_id":"device-1","device_code":"SMART-LAMP-123","data":{"power":true,"brightness":75}}',
    );

    expect(event.type, 'device.state');
    expect(event.deviceId, 'device-1');
    expect(event.data, {'power': true, 'brightness': 75});
  });

  test(
    'reconnects after socket closes without closing shared event stream',
    () async {
      final connections = <_FakeConnection>[];
      final client = WsClient(
        connector: (_) {
          final connection = _FakeConnection();
          connections.add(connection);
          return connection.connection;
        },
        reconnectDelays: const [Duration.zero],
      );
      addTearDown(client.disconnect);

      final events = <DeviceEvent>[];
      final subscription = client
          .connect(() async => 'token')
          .listen(events.add);
      addTearDown(subscription.cancel);
      await _eventually(() => connections.isNotEmpty);
      expect(connections, hasLength(1));

      await connections.first.messages.close();
      await _eventually(() => connections.length == 2);
      connections.last.messages.add(
        '{"type":"device.state","device_id":"device-1","data":{"power":true}}',
      );
      await _eventually(() => events.length == 1);

      expect(events.single.data, {'power': true});
    },
  );

  test(
    'reconnect fetches a fresh token instead of reusing the first',
    () async {
      final connections = <_FakeConnection>[];
      final uris = <Uri>[];
      var token = 'stale';
      final client = WsClient(
        connector: (uri) {
          uris.add(uri);
          final connection = _FakeConnection();
          connections.add(connection);
          return connection.connection;
        },
        reconnectDelays: const [Duration.zero],
      );
      addTearDown(client.disconnect);

      final subscription = client.connect(() async => token).listen((_) {});
      addTearDown(subscription.cancel);
      await _eventually(() => connections.isNotEmpty);
      expect(uris.first.queryParameters['token'], 'stale');

      // Simulate a JWT refresh that rotates the stored access token, then a
      // dropped socket that forces a reconnect.
      token = 'fresh';
      await connections.first.messages.close();
      await _eventually(() => connections.length == 2);

      expect(uris.last.queryParameters['token'], 'fresh');
    },
  );

  test('disconnect cancels pending reconnect', () async {
    final connections = <_FakeConnection>[];
    final client = WsClient(
      connector: (_) {
        final connection = _FakeConnection();
        connections.add(connection);
        return connection.connection;
      },
      reconnectDelays: const [Duration(milliseconds: 20)],
    );

    client.connect(() async => 'token').listen((_) {});
    await _eventually(() => connections.isNotEmpty);
    await connections.first.messages.close();
    client.disconnect();
    await Future<void>.delayed(const Duration(milliseconds: 40));

    expect(connections, hasLength(1));
  });
}

Future<void> _eventually(bool Function() condition) async {
  for (var i = 0; i < 20 && !condition(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(condition(), isTrue);
}

class _FakeConnection {
  final messages = StreamController<dynamic>();
  var closed = false;

  late final WsConnection connection = WsConnection(
    stream: messages.stream,
    close: () {
      closed = true;
      messages.close();
    },
  );
}
