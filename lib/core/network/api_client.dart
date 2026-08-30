import 'package:dio/dio.dart';

import 'endpoints.dart';
import 'token_storage.dart';

/// Fires once when a refresh fails (expired session) so the app can bounce
/// to sign-in. The router listens to this instead of auth state polling.
typedef UnauthorizedCallback = void Function();

/// Single Dio instance for the whole app, mirroring orqestra_fe's
/// shared axios: attach bearer token, refresh once on 401 (deduped), retry.
class ApiClient {
  ApiClient({required this.tokenStorage, this.onUnauthorized}) {
    dio = Dio(BaseOptions(baseUrl: apiBaseUrl, connectTimeout: const Duration(seconds: 15)));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['skipAuth'] != true) {
            final token = await tokenStorage.accessToken;
            if (token != null) options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Backend wraps every success in {data, message, meta?}. Unwrap here
          // so repositories read the payload directly instead of each one
          // reaching through the envelope.
          final body = response.data;
          if (body is Map && body.containsKey('data')) response.data = body['data'];
          handler.next(response);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;
          if (!isUnauthorized || alreadyRetried || error.requestOptions.extra['skipAuth'] == true) {
            handler.next(_normalize(error));
            return;
          }

          try {
            final refreshed = await _refreshOnce();
            if (!refreshed) throw error;
            final req = error.requestOptions;
            req.extra['retried'] = true;
            final token = await tokenStorage.accessToken;
            req.headers['Authorization'] = 'Bearer $token';
            handler.resolve(await dio.fetch(req));
          } catch (_) {
            await tokenStorage.clear();
            onUnauthorized?.call();
            handler.next(_normalize(error));
          }
        },
      ),
    );
  }

  final TokenStorage tokenStorage;
  final UnauthorizedCallback? onUnauthorized;
  late final Dio dio;

  Future<bool>? _refreshInFlight;

  /// Dedupe concurrent refreshes the same way the FE axios instance does —
  /// one refresh call serves every 401 that piles up while it's in flight.
  Future<bool> _refreshOnce() {
    return _refreshInFlight ??= _doRefresh().whenComplete(() => _refreshInFlight = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await tokenStorage.refreshToken;
    if (refreshToken == null) return false;
    try {
      final res = await dio.post(
        Endpoints.refresh,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );
      await tokenStorage.save(
        accessToken: res.data['access_token'] as String,
        refreshToken: res.data['refresh_token'] as String,
      );
      return true;
    } on DioException {
      return false;
    }
  }

  /// `handler.next` requires a DioException, so wrap the readable message
  /// back into one instead of returning a bare Exception.
  DioException _normalize(DioException e) {
    final data = e.response?.data;
    final message = (data is Map ? (data['errors'] ?? data['message']) : null) ?? e.message;
    return e.copyWith(message: message.toString());
  }
}
