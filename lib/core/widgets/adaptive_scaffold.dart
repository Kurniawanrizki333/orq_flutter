import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_mode_controller.dart';

class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.body,
    this.actions = const [],
    this.floatingActionButton,
  });

  final String title;
  final int selectedIndex;
  final Widget body;
  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useRail = MediaQuery.sizeOf(context).width >= 720;
    final scaffold = Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 28, height: 28),
            const SizedBox(width: 10),
            Flexible(child: Text(title)),
          ],
        ),
        actions: [
          ...actions,
          _ThemeModeMenu(ref: ref),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _go(context, index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.devices_outlined),
                  selectedIcon: Icon(Icons.devices),
                  label: 'Devices',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bolt_outlined),
                  selectedIcon: Icon(Icons.bolt),
                  label: 'Automations',
                ),
              ],
            ),
      body: body,
    );

    if (!useRail) return scaffold;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _go(context, index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.devices_outlined),
                selectedIcon: Icon(Icons.devices),
                label: Text('Devices'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bolt_outlined),
                selectedIcon: Icon(Icons.bolt),
                label: Text('Automations'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: scaffold),
        ],
      ),
    );
  }

  void _go(BuildContext context, int index) {
    if (index == selectedIndex) return;
    context.go(index == 0 ? '/' : '/automations');
  }
}

class _ThemeModeMenu extends StatelessWidget {
  const _ThemeModeMenu({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final mode = ref
        .watch(themeModeControllerProvider)
        .when(
          data: (mode) => mode,
          loading: () => ThemeMode.system,
          error: (_, _) => ThemeMode.system,
        );
    return PopupMenuButton<ThemeMode>(
      tooltip: 'Theme',
      icon: Icon(_iconFor(mode)),
      onSelected: (selectedMode) {
        ref.read(themeModeControllerProvider.notifier).setMode(selectedMode);
      },
      itemBuilder: (context) => [
        _item(ThemeMode.light, mode, 'Light', Icons.light_mode_outlined),
        _item(ThemeMode.dark, mode, 'Dark', Icons.dark_mode_outlined),
        _item(ThemeMode.system, mode, 'System', Icons.brightness_auto_outlined),
      ],
    );
  }

  PopupMenuItem<ThemeMode> _item(
    ThemeMode value,
    ThemeMode activeMode,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          if (value == activeMode) const Icon(Icons.check),
        ],
      ),
    );
  }

  IconData _iconFor(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Icons.light_mode_outlined,
    ThemeMode.dark => Icons.dark_mode_outlined,
    ThemeMode.system => Icons.brightness_auto_outlined,
  };
}
