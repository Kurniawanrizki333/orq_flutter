import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/sign_in_page.dart';
import '../../features/auth/sign_up_page.dart';
import '../../features/automations/automation_form_page.dart';
import '../../features/automations/automation_list_page.dart';
import '../../features/devices/device_detail_page.dart';
import '../../features/devices/device_list_page.dart';
import '../../features/devices/device_models.dart';
import '../../features/pairing/claim_preview_page.dart';
import '../../features/pairing/scan_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final loggedIn = auth.value != null;
  final resolving = auth.isLoading && !auth.hasValue;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (resolving) return null;
      final onAuthPages = state.matchedLocation == '/sign-in' || state.matchedLocation == '/sign-up';
      if (!loggedIn && !onAuthPages) return '/sign-in';
      if (loggedIn && onAuthPages) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/sign-in', builder: (context, state) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (context, state) => const SignUpPage()),
      GoRoute(path: '/', builder: (context, state) => const DeviceListPage()),
      GoRoute(
        path: '/devices/:id',
        builder: (context, state) => DeviceDetailPage(device: state.extra as Device),
      ),
      GoRoute(path: '/pair/scan', builder: (context, state) => const ScanPage()),
      GoRoute(
        path: '/pair/claim',
        builder: (context, state) {
          final args = state.extra as Map<String, String>;
          return ClaimPreviewPage(deviceCode: args['device_code']!, pairingToken: args['pairing_token']!);
        },
      ),
      GoRoute(path: '/automations', builder: (context, state) => const AutomationListPage()),
      GoRoute(path: '/automations/new', builder: (context, state) => const AutomationFormPage()),
    ],
  );
});
