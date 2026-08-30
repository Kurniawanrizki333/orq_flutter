import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import 'automation_models.dart';
import 'automation_repository.dart';

final automationRepositoryProvider = Provider<AutomationRepository>((ref) {
  return AutomationRepository(ref.read(apiClientProvider));
});

final automationsProvider = FutureProvider<List<Automation>>((ref) {
  return ref.read(automationRepositoryProvider).list();
});
