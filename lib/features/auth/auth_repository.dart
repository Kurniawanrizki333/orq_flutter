import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import 'auth_models.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<AuthUser?> restoreSession() async {
    final token = await _client.tokenStorage.accessToken;
    if (token == null) return null;
    // ponytail: no /me endpoint wired yet, so a stored token is trusted as-is;
    // add a profile fetch here once /iot/v1 (or /core/v1/auth/me) is confirmed live.
    return null;
  }

  Future<AuthUser> signIn({required String login, required String password}) async {
    final res = await _client.dio.post(Endpoints.signIn, data: {'login': login, 'password': password});
    final data = res.data as Map<String, dynamic>;
    await _client.tokenStorage.save(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  // ponytail: assumes consumer-signup auto-signs-in like /core/v1/auth/signin
  // (access_token/refresh_token/user in the body). Backend not built yet —
  // adjust parsing once /iot/v1/auth/consumer-signup ships for real.
  Future<AuthUser> signUp({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    final res = await _client.dio.post(
      Endpoints.consumerSignUp,
      data: {'email': email, 'username': username, 'password': password, 'full_name': ?fullName},
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
