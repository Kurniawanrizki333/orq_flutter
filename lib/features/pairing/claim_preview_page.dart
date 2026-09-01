import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/responsive_page.dart';
import '../../core/widgets/section_card.dart';
import '../devices/device_providers.dart';
import '../devices/device_repository.dart';

class ClaimPreviewPage extends ConsumerStatefulWidget {
  const ClaimPreviewPage({
    super.key,
    required this.deviceCode,
    required this.pairingToken,
  }) : invalid = false;

  const ClaimPreviewPage.invalid({super.key})
    : deviceCode = '',
      pairingToken = '',
      invalid = true;

  final String deviceCode;
  final String pairingToken;
  final bool invalid;

  @override
  ConsumerState<ClaimPreviewPage> createState() => _ClaimPreviewPageState();
}

class _ClaimPreviewPageState extends ConsumerState<ClaimPreviewPage> {
  bool _claiming = false;
  String? _error;
  Future<ClaimPreview>? _preview;

  @override
  void initState() {
    super.initState();
    if (!widget.invalid) _preview = _loadPreview();
  }

  Future<ClaimPreview> _loadPreview() {
    return ref
        .read(deviceRepositoryProvider)
        .claimPreview(
          deviceCode: widget.deviceCode,
          pairingToken: widget.pairingToken,
        );
  }

  void _retryPreview() => setState(() {
    _error = null;
    _preview = _loadPreview();
  });

  Future<void> _claim() async {
    setState(() {
      _claiming = true;
      _error = null;
    });
    try {
      await ref
          .read(deviceRepositoryProvider)
          .claim(
            deviceCode: widget.deviceCode,
            pairingToken: widget.pairingToken,
          );
      ref.invalidate(myDevicesProvider);
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_claiming,
      child: Scaffold(
        appBar: AppBar(title: const Text('Claim device')),
        body: widget.invalid
            ? AppStateView.empty(
                icon: Icons.link_off,
                title: 'Invalid pairing link',
                message: 'Scan the device QR code again to continue.',
                actionLabel: 'Scan again',
                onAction: () => context.go('/pair/scan'),
              )
            : FutureBuilder<ClaimPreview>(
                future: _preview,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const AppStateView.loading(
                      message: 'Verifying pairing details.',
                    );
                  }
                  if (snapshot.hasError) {
                    return AppStateView.error(
                      title: 'Could not verify device',
                      message: snapshot.error.toString(),
                      actionLabel: 'Retry',
                      onAction: _retryPreview,
                    );
                  }
                  return _buildPreview(context, snapshot.requireData);
                },
              ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, ClaimPreview preview) {
    return SingleChildScrollView(
      child: ResponsivePage(
        maxWidth: 520,
        padding: const EdgeInsets.all(24),
        child: SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.devices_other,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Verify device',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Review the verified device before claiming it.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              SelectableText(
                preview.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${preview.productName}${preview.productCategory == null ? '' : ' · ${preview.productCategory}'}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              SelectableText(preview.deviceCode, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final capability in preview.capabilities)
                    Chip(label: Text(capability.name)),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                _ErrorBanner(message: _error!),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _claiming ? null : _claim,
                child: _claiming
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Claim this device'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _claiming ? null : () => context.go('/pair/scan'),
                child: const Text('Scan again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
