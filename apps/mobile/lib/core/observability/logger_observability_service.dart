import 'package:logging/logging.dart';

import 'observability_service.dart';

class LoggerObservability implements ObservabilityService {
  LoggerObservability({Logger? logger}) : _logger = logger ?? Logger('Arena');

  final Logger _logger;

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? data,
  }) {
    final formattedMessage = _formatMessage(message, data);

    switch (level) {
      case LogLevel.debug:
        _logger.fine(formattedMessage);

      case LogLevel.info:
        _logger.info(formattedMessage);

      case LogLevel.warning:
        _logger.warning(formattedMessage, error, stackTrace);

      case LogLevel.error:
        _logger.severe(formattedMessage, error, stackTrace);
    }
  }

  @override
  void addBreadcrumb(
    String message, {
    String? category,
    Map<String, Object?>? data,
  }) {
    final label = category == null ? 'Breadcrumb' : 'Breadcrumb ($category)';
    _logger.fine(_formatMessage('$label: $message', data));
  }

  @override
  void captureEvent(String name, {Map<String, Object?>? properties}) {
    _logger.info(_formatMessage('Event: $name', properties));
  }

  @override
  void captureException(
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?>? context,
  }) {
    _logger.severe(
      _formatMessage('Unhandled exception', context),
      error,
      stackTrace,
    );
  }

  @override
  void setUser({required String id, String? email}) {
    _logger.fine('Observability user set: $id');
  }

  @override
  void clearUser() {
    _logger.fine('Observability user cleared');
  }

  @override
  void setContext(String name, Map<String, Object?> data) {
    _logger.fine(_formatMessage('Context: $name', data));
  }

  String _formatMessage(String message, Map<String, Object?>? data) {
    if (data == null || data.isEmpty) {
      return message;
    }

    return '$message | $data';
  }
}
