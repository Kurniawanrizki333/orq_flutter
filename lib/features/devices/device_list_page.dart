import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/adaptive_scaffold.dart';
import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/responsive_page.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';
import '../auth/auth_controller.dart';
import 'device_models.dart';
import 'device_providers.dart';

class DeviceListPage extends ConsumerStatefulWidget {
  const DeviceListPage({super.key});

  @override
  ConsumerState<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends ConsumerState<DeviceListPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(myDevicesProvider);

    return AdaptiveScaffold(
      title: 'Devices',
      selectedIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sign out',
          onPressed: _confirmSignOut,
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Pair device',
        onPressed: () => context.push('/pair/scan'),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Pair'),
      ),
      body: devices.when(
        loading: () => const AppStateView.loading(message: 'Loading fleet.'),
        error: (err, _) => AppStateView.error(
          message: err.toString(),
          onAction: () => ref.invalidate(myDevicesProvider),
        ),
        data: _buildDevices,
      ),
    );
  }

  Widget _buildDevices(List<Device> list) {
    final query = _query.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? list
        : list.where((d) => d.name.toLowerCase().contains(query)).toList();
    final online = list.where((d) => d.online).length;

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myDevicesProvider.future),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ResponsivePage(
            maxWidth: 1100,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FleetHeader(total: list.length, online: online),
                const SizedBox(height: 16),
                TextField(
                  controller: _query,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search devices',
                    hintText: 'Lamp, sensor, gateway',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  AppStateView.empty(
                    icon: Icons.qr_code_scanner,
                    title: 'No devices paired',
                    message: 'Scan a device QR code to start monitoring and controlling your fleet.',
                    actionLabel: 'Pair device',
                    onAction: () => context.push('/pair/scan'),
                  )
                else if (filtered.isEmpty)
                  const AppStateView.empty(
                    icon: Icons.search_off,
                    title: 'No matching devices',
                    message: 'Try another name or clear the search field.',
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 760 ? 2 : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 140,
                        ),
                        itemBuilder: (context, i) =>
                            _DeviceCard(device: filtered[i]),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need to sign in again to control your devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}

class _FleetHeader extends StatelessWidget {
  const _FleetHeader({required this.total, required this.online});

  final int total;
  final int online;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IoT fleet', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  'Monitor, control, and pair capability-driven devices.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _Stat(label: 'Total', value: '$total'),
          const SizedBox(width: 12),
          _Stat(label: 'Online', value: '$online'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: theme.textTheme.headlineSmall),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/devices/${device.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.devices, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      device.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  _DeviceStatusBadge(status: device.status),
                ],
              ),
              const Spacer(),
              Text(
                '${device.capabilities.length} capabilities',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Product ${device.productId}',
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceStatusBadge extends StatelessWidget {
  const _DeviceStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toUpperCase();
    return switch (normalized) {
      'ONLINE' => const StatusBadge(
        label: 'Online',
        icon: Icons.check_circle,
        color: Color(0xFF32D583),
      ),
      'OFFLINE' => StatusBadge(
        label: 'Offline',
        icon: Icons.wifi_off,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      'DISABLED' => const StatusBadge(
        label: 'Disabled',
        icon: Icons.block,
        color: Color(0xFFF5B942),
      ),
      'UNCLAIMED' => const StatusBadge(
        label: 'Unclaimed',
        icon: Icons.link_off,
        color: Color(0xFF4F8CFF),
      ),
      _ => StatusBadge(
        label: status,
        icon: Icons.help_outline,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    };
  }
}
