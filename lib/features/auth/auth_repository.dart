import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import 'auth_models.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<AuthUser?> restoreSession() async {
    if (await _client.tokenStorage.accessToken == null) {
      if (await _client.tokenStorage.refreshToken == null ||
          !await _client.refreshSession()) {
        return null;
      }
    }
    try {
      final res = await _client.dio.get(Endpoints.me);
      final data = res.data as Map<String, dynamic>;
      return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    } catch (_) {
      // The interceptor refreshes 401s and clears only an expired session.
      if (await _client.tokenStorage.accessToken == null) return null;
      rethrow;
    }
  }

  Future<AuthUser> signIn({
    required String login,
    required String password,
  }) async {
    final res = await _client.dio.post(
      Endpoints.signIn,
      data: {'login': login, 'password': password},
    );
    final data = res.data as Map<String, dynamic>;
    await _client.tokenStorage.save(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<AuthUser> signUp({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    final res = await _client.dio.post(
      Endpoints.consumerSignUp,
      data: {
        'email': email,
        'username': username,
        'password': password,
        'full_name': ?fullName,
      },
    );
    final data = res.data as Map<String, dynamic>;
    await _client.tokenStorage.save(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> signOut() => _client.tokenStorage.clear();
}
