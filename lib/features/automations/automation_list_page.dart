import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/adaptive_scaffold.dart';
import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/responsive_page.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';
import 'automation_models.dart';
import 'automation_providers.dart';

class AutomationListPage extends ConsumerStatefulWidget {
  const AutomationListPage({super.key});

  @override
  ConsumerState<AutomationListPage> createState() => _AutomationListPageState();
}

class _AutomationListPageState extends ConsumerState<AutomationListPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final automations = ref.watch(automationsProvider);

    return AdaptiveScaffold(
      title: 'Automations',
      selectedIndex: 1,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Create automation',
        onPressed: () => context.push('/automations/new'),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: automations.when(
        loading: () =>
            const AppStateView.loading(message: 'Loading automation rules.'),
        error: (err, _) => AppStateView.error(
          message: err.toString(),
          onAction: () => ref.invalidate(automationsProvider),
        ),
        data: _buildAutomations,
      ),
    );
  }

  Widget _buildAutomations(List<Automation> list) {
    final query = _query.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? list
        : list.where((a) => a.name.toLowerCase().contains(query)).toList();
    final enabled = list.where((a) => a.enabled == true).length;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(automationsProvider);
        // Wait for the provider to complete rebuilding.
        await ref.read(automationsProvider.future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ResponsivePage(
            maxWidth: 960,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rule orchestration',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Coordinate devices with AI-assisted and manual rules.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      _Stat(label: 'Rules', value: '${list.length}'),
                      const SizedBox(width: 12),
                      _Stat(label: 'Enabled', value: '$enabled'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _query,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search automations',
                    hintText: 'Night lights, fan, temperature',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  AppStateView.empty(
                    icon: Icons.bolt_outlined,
                    title: 'No automations yet',
                    message: 'Create a rule to react to device state or schedule routine actions.',
                    actionLabel: 'Create automation',
                    onAction: () => context.push('/automations/new'),
                  )
                else if (filtered.isEmpty)
                  const AppStateView.empty(
                    icon: Icons.search_off,
                    title: 'No matching rules',
                    message: 'Try another automation name.',
                  )
                else ...[
                  for (final automation in filtered) ...[
                    _AutomationCard(
                      automation: automation,
                      onToggle: (enabled) =>
                          _handleToggle(automation.id, enabled),
                      onDelete: () => _handleDelete(automation),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleToggle(String id, bool enabled) async {
    try {
      await ref.read(automationsProvider.notifier).toggle(id, enabled);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  Future<void> _handleDelete(Automation automation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete automation?'),
        content: Text('This will permanently remove "${automation.name}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(automationsProvider.notifier).delete(automation.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('"${automation.name}" deleted')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

String _triggerSummary(Map<String, dynamic>? trigger) {
  if (trigger == null) return 'No trigger';
  if (trigger['type'] == 'schedule') return 'Schedule at ${trigger['at']}';
  final cap = trigger['capability'] ?? '';
  final op = trigger['operator'] ?? '';
  final val = trigger['value'] ?? '';
  return '$cap $op $val';
}

class _AutomationCard extends StatelessWidget {
  const _AutomationCard({
    required this.automation,
    required this.onToggle,
    required this.onDelete,
  });

  final Automation automation;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final actions = automation.actions.length;
    final trigger = _triggerSummary(automation.trigger);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        automation.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$trigger · $actions ${actions == 1 ? 'action' : 'actions'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Delete'),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                automation.enabled
                    ? const StatusBadge(
                        label: 'Enabled',
                        icon: Icons.check_circle,
                        color: Color(0xFF32D583),
                      )
                    : StatusBadge(
                        label: 'Disabled',
                        icon: Icons.pause_circle,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                const Spacer(),
                Switch.adaptive(value: automation.enabled, onChanged: onToggle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
