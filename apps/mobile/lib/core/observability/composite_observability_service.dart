import 'dart:async';

import 'observability_service.dart';

/// Fans every observability call out to each delegate, in list order.
///
/// This is the seam that lets the app talk to one [ObservabilityService]
/// while Sentry, Firebase, or anything else is added behind it later.
///
/// A delegate that throws is isolated: one broken backend can never take
/// down the caller or stop the remaining backends from recording the same
/// call. Observability is never important enough to break a feature.
class CompositeObservabilityService implements ObservabilityService {
  const CompositeObservabilityService(this._services);

  final List<ObservabilityService> _services;

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? data,
  }) => _fanOut(
    (service) => service.log(
      level,
      message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    ),
  );

  @override
  void addBreadcrumb(
    String message, {
    String? category,
    Map<String, Object?>? data,
  }) => _fanOut(
    (service) => service.addBreadcrumb(message, category: category, data: data),
  );

  @override
  void captureEvent(String name, {Map<String, Object?>? properties}) =>
      _fanOut((service) => service.captureEvent(name, properties: properties));

  @override
  void captureException(
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?>? context,
  }) => _fanOut(
    (service) => service.captureException(error, stackTrace, context: context),
  );

  @override
  void setUser({required String id, String? email}) =>
      _fanOut((service) => service.setUser(id: id, email: email));

  @override
  void clearUser() => _fanOut((service) => service.clearUser());

  @override
  void setContext(String name, Map<String, Object?> data) =>
      _fanOut((service) => service.setContext(name, data));

  void _fanOut(void Function(ObservabilityService service) call) {
    for (final service in _services) {
      try {
        call(service);
      } catch (error, stackTrace) {
        // Hand the failure to the zone rather than back through the other
        // services: it stays visible to the app's error handling and cannot
        // loop back into this composite.
        Zone.current.handleUncaughtError(error, stackTrace);
      }
    }
  }
}
