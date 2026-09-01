import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
        actions: actions,
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
