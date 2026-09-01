import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// QR payload format (PRD §23): orqestra://pair/{device_code}/{token}
({String deviceCode, String pairingToken})? parsePairingQr(String raw) {
  final uri = Uri.tryParse(raw);
  if (uri == null ||
      uri.scheme != 'orqestra' ||
      uri.host != 'pair' ||
      uri.pathSegments.length != 2) {
    return null;
  }
  final deviceCode = uri.pathSegments[0];
  final token = uri.pathSegments[1];
  if (deviceCode.isEmpty || token.isEmpty) return null;
  return (deviceCode: deviceCode, pairingToken: token);
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _handled = false;
  String? _error;
  int _scannerGeneration = 0;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final payload = parsePairingQr(raw);
    if (payload == null) {
      setState(() => _error = 'Invalid Orqestra QR code.');
      return;
    }

    setState(() {
      _handled = true;
      _error = null;
    });
    await context.push(
      '/pair/claim',
      extra: {
        'device_code': payload.deviceCode,
        'pairing_token': payload.pairingToken,
      },
    );
    if (mounted) setState(() => _handled = false);
  }

  void _retryCamera() => setState(() {
    _scannerGeneration++;
    _handled = false;
    _error = null;
  });

  Future<void> _enterManually() async {
    final deviceCode = TextEditingController();
    final token = TextEditingController();
    final key = GlobalKey<FormState>();
    final payload = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter pairing details'),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: deviceCode,
                decoration: const InputDecoration(labelText: 'Device code'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Device code required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: token,
                decoration: const InputDecoration(labelText: 'Pairing token'),
                validator: (value) => value == null || value.trim().length < 16
                    ? 'Enter the full pairing token'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!key.currentState!.validate()) return;
              Navigator.pop(context, {
                'device_code': deviceCode.text.trim(),
                'pairing_token': token.text.trim(),
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    deviceCode.dispose();
    token.dispose();
    if (payload != null && mounted) {
      await context.push('/pair/claim', extra: payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan device QR')),
      body: Stack(
        children: [
          MobileScanner(
            key: ValueKey(_scannerGeneration),
            onDetect: _onDetect,
            errorBuilder: (context, error) => _CameraError(
              permissionDenied:
                  error.errorCode == MobileScannerErrorCode.permissionDenied,
              onRetry: _retryCamera,
              onManual: _enterManually,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.24),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _handled
                          ? 'Opening claim preview...'
                          : 'Place the device QR code inside the frame.',
                      textAlign: TextAlign.center,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _enterManually,
                      icon: const Icon(Icons.keyboard),
                      label: const Text('Enter code and token manually'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({
    required this.permissionDenied,
    required this.onRetry,
    required this.onManual,
  });

  final bool permissionDenied;
  final VoidCallback onRetry;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                permissionDenied
                    ? 'Camera permission denied. Allow camera access in system settings, then retry.'
                    : 'Camera could not start. Retry or pair manually.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Retry camera'),
              ),
              TextButton(
                onPressed: onManual,
                child: const Text('Enter manually'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
