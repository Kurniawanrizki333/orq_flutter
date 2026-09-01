import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/responsive_page.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';
import 'capability_control.dart';
import 'device_models.dart';
import 'device_providers.dart';

class DeviceDetailPage extends ConsumerWidget {
  const DeviceDetailPage({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(myDevicesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Device detail')),
      body: devices.when(
        loading: () => const AppStateView.loading(message: 'Loading device.'),
        error: (error, _) => AppStateView.error(
          message: error.toString(),
          onAction: () => ref.invalidate(myDevicesProvider),
        ),
        data: (items) {
          final device = _findDevice(items, deviceId);
          if (device == null) {
            return const AppStateView.empty(
              icon: Icons.devices_other,
              title: 'Device not found',
              message:
                  'This device may have been removed or your access changed.',
            );
          }
          return _DeviceDetail(device: device);
        },
      ),
    );
  }
}

class _DeviceDetail extends ConsumerWidget {
  const _DeviceDetail({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = ref.watch(deviceStateProvider(device.id));
    final controller = ref.read(deviceStateProvider(device.id).notifier);
    return values.when(
      loading: () => const AppStateView.loading(message: 'Loading live state.'),
      error: (error, _) => AppStateView.error(
        message: error.toString(),
        onAction: () => ref.invalidate(deviceStateProvider(device.id)),
      ),
      data: (state) => ListView(
        children: [
          ResponsivePage(
            maxWidth: 920,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DeviceOverview(device: device),
                const SizedBox(height: 16),
                if (device.capabilities.isEmpty)
                  const AppStateView.empty(
                    icon: Icons.tune,
                    title: 'No capabilities',
                    message: 'This device has no controllable or readable capabilities yet.',
                  )
                else
                  SectionCard(
                    title: 'Capabilities',
                    subtitle: device.online ? 'Realtime values and controls.' : 'Device is offline. Commands may fail until it reconnects.',
                    child: Column(
                      children: [
                        for (final capability in device.capabilities) ...[
                          CapabilityControl(
                            capability: capability,
                            value: state[capability.key],
                            enabled:
                                device.online &&
                                !controller.isPending(capability.key),
                            pending: controller.isPending(capability.key),
                            onChanged: (value) async {
                              try {
                                await ref
                                    .read(
                                      deviceStateProvider(device.id).notifier,
                                    )
                                    .setCapability(capability.key, value);
                              } catch (error) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Command failed: $error'),
                                  ),
                                );
                              }
                            },
                          ),
                          if (capability != device.capabilities.last)
                            const Divider(height: 24),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceOverview extends StatelessWidget {
  const _DeviceOverview({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      child: Row(
        children: [
          Icon(Icons.memory, color: theme.colorScheme.primary, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Product ${device.productId} · ${device.capabilities.length} capabilities',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _DeviceStatusBadge(status: device.status),
        ],
      ),
    );
  }
}

class _DeviceStatusBadge extends StatelessWidget {
  const _DeviceStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return switch (status.toUpperCase()) {
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

Device? _findDevice(List<Device> devices, String id) {
  for (final device in devices) {
    if (device.id == id) return device;
  }
  return null;
}
