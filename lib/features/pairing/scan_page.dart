import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// QR payload format (PRD §23): orqestra://pair/{device_code}/{token}
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final uri = Uri.tryParse(raw);
    if (uri == null || uri.scheme != 'orqestra' || uri.host != 'pair' || uri.pathSegments.length < 2) return;

    _handled = true;
    final deviceCode = uri.pathSegments[0];
    final token = uri.pathSegments[1];
    context.push('/pair/claim', extra: {'device_code': deviceCode, 'pairing_token': token});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan device QR')),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
