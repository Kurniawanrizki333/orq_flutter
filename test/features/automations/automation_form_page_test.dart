import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/features/auth/auth_controller.dart';
import 'package:orqestra_flutter/features/automations/automation_form_page.dart';

void main() {
  testWidgets('empty AI prompt shows visible validation error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [activeUserIdProvider.overrideWithValue(null)],
        child: const MaterialApp(home: AutomationFormPage()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Generate draft'));
    await tester.pump();

    expect(find.text('Describe the automation first.'), findsOneWidget);
  });

  testWidgets('manual mode uses device selectors and visible validation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [activeUserIdProvider.overrideWithValue(null)],
        child: const MaterialApp(home: AutomationFormPage()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Manual'));
    await tester.pump();

    expect(find.text('Trigger device'), findsOneWidget);
    expect(find.text('Action device'), findsOneWidget);
    expect(find.text('Trigger device ID'), findsNothing);
    final save = find.text('Save manual rule');
    await tester.tap(save);
    await tester.pump();
    expect(find.text('Rule name required'), findsOneWidget);
  });
}
