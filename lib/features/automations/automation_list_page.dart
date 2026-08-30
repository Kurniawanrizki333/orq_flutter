import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'automation_providers.dart';

class AutomationListPage extends ConsumerWidget {
  const AutomationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final automations = ref.watch(automationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Automations')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/automations/new'),
        child: const Icon(Icons.add),
      ),
      body: automations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No automations yet.'))
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final a = list[i];
                  return ListTile(
                    leading: Icon(a.enabled ? Icons.bolt : Icons.bolt_outlined),
                    title: Text(a.name),
                    subtitle: Text('${a.actions.length} action(s)'),
                  );
                },
              ),
      ),
    );
  }
}
