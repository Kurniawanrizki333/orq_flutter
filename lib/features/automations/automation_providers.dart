import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import 'automation_models.dart';
import 'automation_repository.dart';

final automationRepositoryProvider = Provider<AutomationRepository>((ref) {
  return AutomationRepository(ref.read(apiClientProvider));
});

final automationsProvider =
    AsyncNotifierProvider<AutomationsController, List<Automation>>(
      AutomationsController.new,
    );

class AutomationsController extends AsyncNotifier<List<Automation>> {
  AutomationRepository get _repo => ref.read(automationRepositoryProvider);

  @override
  Future<List<Automation>> build() {
    final userId = ref.watch(activeUserIdProvider);
    return userId == null ? Future.value([]) : _repo.list();
  }

  /// Optimistic toggle with rollback on failure.
  Future<void> toggle(String id, bool enabled) async {
    final previous = state.value;
    if (previous == null) return;

    // Optimistic update
    state = AsyncData([
      for (final a in previous)
        if (a.id == id) a.copyWith(enabled: enabled) else a,
    ]);

    try {
      await _repo.update(id, enabled: enabled);
    } catch (e) {
      // Rollback on failure
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Optimistic delete with rollback on failure.
  Future<void> delete(String id) async {
    final previous = state.value;
    if (previous == null) return;

    // Optimistic removal
    state = AsyncData([
      for (final a in previous)
        if (a.id != id) a,
    ]);

    try {
      await _repo.delete(id);
    } catch (e) {
      // Rollback on failure
      state = AsyncData(previous);
      rethrow;
    }
  }
}
