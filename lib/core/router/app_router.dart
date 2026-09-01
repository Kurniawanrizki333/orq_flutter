import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/sign_in_page.dart';
import '../../features/auth/sign_up_page.dart';
import '../../features/automations/automation_form_page.dart';
import '../../features/automations/automation_list_page.dart';
import '../../features/devices/device_detail_page.dart';
import '../../features/devices/device_list_page.dart';
import '../../features/pairing/claim_preview_page.dart';
import '../../features/pairing/scan_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final loggedIn = auth.value != null;
  final resolving = auth.isLoading && !auth.hasValue;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final startup = state.matchedLocation == '/startup';
      if ((resolving || auth.hasError) && !startup) return '/startup';
      if (startup && (resolving || auth.hasError)) return null;
      final onAuthPages =
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';
      if (!loggedIn && !onAuthPages) return '/sign-in';
      if (loggedIn && onAuthPages) return '/';
      if (startup) return loggedIn ? '/' : '/sign-in';
      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => const _StartupGate(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(path: '/', builder: (context, state) => const DeviceListPage()),
      GoRoute(
        path: '/devices/:id',
        builder: (context, state) =>
            DeviceDetailPage(deviceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pair/scan',
        builder: (context, state) => const ScanPage(),
      ),
      GoRoute(
        path: '/pair/claim',
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is Map<String, String> ? extra : null;
          if (args == null ||
              args['device_code'] == null ||
              args['pairing_token'] == null) {
            return const ClaimPreviewPage.invalid();
          }
          return ClaimPreviewPage(
            deviceCode: args['device_code']!,
            pairingToken: args['pairing_token']!,
          );
        },
      ),
      GoRoute(
        path: '/automations',
        builder: (context, state) => const AutomationListPage(),
      ),
      GoRoute(
        path: '/automations/new',
        builder: (context, state) => const AutomationFormPage(),
      ),
    ],
  );
});

class _StartupGate extends ConsumerWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (!auth.hasError) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not restore your session.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(authControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
