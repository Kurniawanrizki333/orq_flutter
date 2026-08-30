import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'capability_control.dart';
import 'device_models.dart';
import 'device_providers.dart';

class DeviceDetailPage extends ConsumerWidget {
  const DeviceDetailPage({super.key, required this.device});
  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deviceStateProvider(device.id));

    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (values) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: device.capabilities.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final cap = device.capabilities[i];
            return CapabilityControl(
              capability: cap,
              value: values[cap.key],
              onChanged: (v) {
                ref.read(deviceRepositoryProvider).sendCommand(device.id, capability: cap.key, value: v);
              },
            );
          },
        ),
      ),
    );
  }
}
