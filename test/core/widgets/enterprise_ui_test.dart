import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/core/theme/app_theme.dart';
import 'package:orqestra_flutter/core/widgets/adaptive_scaffold.dart';
import 'package:orqestra_flutter/core/widgets/app_state_view.dart';

void main() {
  test('enterprise themes use Material 3 component configuration', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.useMaterial3, isTrue);
    expect(dark.useMaterial3, isTrue);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(light.inputDecorationTheme.filled, isTrue);
    expect(dark.cardTheme.shape, isA<RoundedRectangleBorder>());
  });

  testWidgets('error state exposes and invokes recovery action', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppStateView.error(
          message: 'Network unavailable',
          onAction: () => retries++,
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Network unavailable'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('compact width uses bottom navigation', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: AdaptiveScaffold(
          title: 'Devices',
          selectedIndex: 0,
          body: SizedBox(),
        ),
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('expanded width uses navigation rail', (tester) async {
    tester.view.physicalSize = const Size(840, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: AdaptiveScaffold(
          title: 'Devices',
          selectedIndex: 0,
          body: SizedBox(),
        ),
      ),
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
