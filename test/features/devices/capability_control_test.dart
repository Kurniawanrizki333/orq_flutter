import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/features/devices/capability_control.dart';
import 'package:orqestra_flutter/features/devices/device_models.dart';

void main() {
  const power = Capability(
    id: 'power-id',
    key: 'power',
    name: 'Power',
    type: 'boolean',
    mode: 'read_write',
  );

  testWidgets('power sends requested value to provider callback', (
    tester,
  ) async {
    final command = Completer<void>();
    dynamic requested;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CapabilityControl(
            capability: power,
            value: false,
            onChanged: (value) {
              requested = value;
              return command.future;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(requested, isTrue);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    command.complete();
  });

  testWidgets('malformed color value does not crash renderer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CapabilityControl(
            capability: const Capability(
              id: 'color-id',
              key: 'color',
              name: 'Color',
              type: 'color',
              mode: 'read_write',
            ),
            value: 'not-a-color',
            onChanged: (_) async {},
          ),
        ),
      ),
    );

    expect(find.text('Color'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled capability does not send a command', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CapabilityControl(
            capability: power,
            value: false,
            enabled: false,
            onChanged: (_) async => calls++,
          ),
        ),
      ),
    );

    expect(tester.widget<Switch>(find.byType(Switch)).onChanged, isNull);
    await tester.tap(find.byType(Switch));
    expect(calls, 0);
  });

  testWidgets('writable number validates bounds before sending', (
    tester,
  ) async {
    dynamic requested;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CapabilityControl(
            capability: const Capability(
              id: 'temperature-id',
              key: 'temperature',
              name: 'Temperature',
              type: 'number',
              mode: 'write',
              min: 10,
              max: 30,
            ),
            value: 20,
            onChanged: (value) async => requested = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '31');
    await tester.tap(find.byTooltip('Send value'));
    await tester.pump();
    expect(find.text('Maximum is 30'), findsOneWidget);
    expect(requested, isNull);

    await tester.enterText(find.byType(TextField), '25');
    await tester.tap(find.byTooltip('Send value'));
    await tester.pump();
    expect(requested, 25);
  });
}
