import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/token_storage.dart';
import 'auth_models.dart';
import 'auth_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    tokenStorage: const TokenStorage(),
    onUnauthorized: () => ref.read(authControllerProvider.notifier).forceSignOut(),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(apiClientProvider));
});

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthUser?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AuthUser?> build() => _repo.restoreSession();

  Future<void> signIn({required String login, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signIn(login: login, password: password));
  }

  Future<void> signUp({required String email, required String username, required String password, String? fullName}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signUp(email: email, username: username, password: password, fullName: fullName),
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AsyncData(null);
  }

  /// Called by [ApiClient] when a refresh fails — tokens are already
  /// cleared by then, this just syncs UI state so the router redirects.
  void forceSignOut() => state = const AsyncData(null);
}
