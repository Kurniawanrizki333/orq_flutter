/// API base URL. Override at build/run time:
/// `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080`
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// WS base URL derived from [apiBaseUrl] unless overridden.
final wsBaseUrl = const String.fromEnvironment('WS_BASE_URL').isNotEmpty
    ? const String.fromEnvironment('WS_BASE_URL')
    : apiBaseUrl.replaceFirst('http', 'ws');

class Endpoints {
  const Endpoints._();

  // core/v1 — shared with the admin FE, consumer only uses signin/refresh.
  static const signIn = '/core/v1/auth/signin';
  static const refresh = '/core/v1/auth/refresh';

  // iot/v1 — consumer-only surface (PRD Phase 1c).
  static const consumerSignUp = '/iot/v1/auth/consumer-signup';
  static const claimDevice = '/iot/v1/devices/claim';
  static const myDevices = '/iot/v1/me/devices';
  static String deviceState(String id) => '/iot/v1/devices/$id/state';
  static String deviceCommands(String id) => '/iot/v1/devices/$id/commands';
  static const automations = '/iot/v1/automations';
  static const automationGenerate = '/iot/v1/automations/generate';
  static String ws(String token) => '$wsBaseUrl/iot/v1/ws?token=$token';
}
