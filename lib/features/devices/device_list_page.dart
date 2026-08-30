import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';
import 'device_models.dart';
import 'device_providers.dart';

class DeviceListPage extends ConsumerWidget {
  const DeviceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(myDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt),
            tooltip: 'Automations',
            onPressed: () => context.push('/automations'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pair/scan'),
        child: const Icon(Icons.qr_code_scanner),
      ),
      body: devices.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No devices yet. Tap the scan button to pair one.'))
            : RefreshIndicator(
                onRefresh: () => ref.refresh(myDevicesProvider.future),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) => _DeviceTile(device: list[i]),
                ),
              ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device});
  final Device device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.devices, color: device.online ? Colors.green : Colors.grey),
      title: Text(device.name),
      subtitle: Text(device.online ? 'Online' : 'Offline'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/devices/${device.id}', extra: device),
    );
  }
}
