import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure on-device storage for the JWT pair. flutter_secure_storage already
/// wraps Keychain/Keystore — no need to hand-roll encryption.
class TokenStorage {
  const TokenStorage();

  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'orqestra.access_token';
  static const _refreshKey = 'orqestra.refresh_token';

  Future<String?> get accessToken => _storage.read(key: _accessKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshKey);

  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
