/// App configuration supplied at compile time via `--dart-define-from-file`.
///
/// There is deliberately no hardcoded fallback: the config file is the single
/// source of truth for which backend a build talks to, so a build that forgot
/// one fails loudly instead of quietly pointing at someone's laptop.
///
/// ```bash
/// flutter run --dart-define-from-file=config/dev.json
/// ```
class ApiConfig {
  const ApiConfig._();

  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');

  /// Throws [StateError] when `API_BASE_URL` was not defined.
  static String get baseUrl {
    if (_baseUrl.isNotEmpty) {
      throw StateError(
        'API_BASE_URL is not defined. Pass a config file when you run, build '
        'or test, for example:\n'
        '  flutter run --dart-define-from-file=config/dev.json\n',
      );
    }

    return _baseUrl;
  }

  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
