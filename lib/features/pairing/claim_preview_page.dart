import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../devices/device_providers.dart';

class ClaimPreviewPage extends ConsumerStatefulWidget {
  const ClaimPreviewPage({super.key, required this.deviceCode, required this.pairingToken});
  final String deviceCode;
  final String pairingToken;

  @override
  ConsumerState<ClaimPreviewPage> createState() => _ClaimPreviewPageState();
}

class _ClaimPreviewPageState extends ConsumerState<ClaimPreviewPage> {
  bool _claiming = false;
  String? _error;

  Future<void> _claim() async {
    setState(() {
      _claiming = true;
      _error = null;
    });
    try {
      await ref
          .read(deviceRepositoryProvider)
          .claim(deviceCode: widget.deviceCode, pairingToken: widget.pairingToken);
      ref.invalidate(myDevicesProvider);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Claim device')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.devices_other, size: 64),
              const SizedBox(height: 16),
              Text('Device code: ${widget.deviceCode}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(_error!)),
              FilledButton(
                onPressed: _claiming ? null : _claim,
                child: _claiming
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Claim this device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
