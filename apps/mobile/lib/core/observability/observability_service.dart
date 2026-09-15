enum LogLevel { debug, info, warning, error }

abstract interface class ObservabilityService {
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? data,
  });

  void addBreadcrumb(
    String message, {
    String? category,
    Map<String, Object?>? data,
  });

  void captureEvent(String name, {Map<String, Object?>? properties});

  void captureException(
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?>? context,
  });

  void setUser({required String id, String? email});

  void clearUser();

  void setContext(String name, Map<String, Object?> data);
}
