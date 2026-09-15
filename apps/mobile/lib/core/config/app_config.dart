/// App configuration supplied at compile time via `--dart-define`.
///
/// There is deliberately no hardcoded fallback: `API_BASE_URL` is the single
/// source of truth for which backend a build talks to, so a build that defines
/// none fails loudly instead of quietly pointing at someone's laptop. A config
/// file is the convenient way to pass it, not the only one.
///
/// ```bash
/// flutter run --dart-define-from-file=config/dev.json
/// flutter run --dart-define=API_BASE_URL=http://localhost:8080
/// ```
class ApiConfig {
  const ApiConfig._();

  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');

  /// Throws [StateError] when `API_BASE_URL` was not defined.
  static String get baseUrl => resolveBaseUrl(_baseUrl);

  /// The check behind [baseUrl], split out because `String.fromEnvironment` is
  /// fixed at compile time and so cannot be exercised from a test.
  static String resolveBaseUrl(String value) {
    if (value.isEmpty) {
      throw StateError(
        'API_BASE_URL is not defined. Define it when you run, build or test, '
        'either from a config file or inline:\n'
        '  flutter run --dart-define-from-file=config/dev.json\n'
        '  flutter run --dart-define=API_BASE_URL=http://localhost:8080\n',
      );
    }

    return value;
  }

  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration sendTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
