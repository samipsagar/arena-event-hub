/// Every failure the app surfaces, in one closed hierarchy.
///
/// The network layer translates Dio errors into these once, at the edge, so
/// nothing above it has to know that Dio exists.
sealed class AppException implements Exception {
  const AppException({required this._message, this.cause, this.stackTrace});

  final String _message;

  /// Safe to show to a user as-is.
  String get message => _message;

  /// The error this was translated from, kept for logs and crash reports.
  ///
  /// Never shown to a user: it may carry internals, and for a 5xx it may not
  /// even come from our backend.
  final Object? cause;

  final StackTrace? stackTrace;

  /// Detail a subclass inserts between the type name and the message.
  String get _detail => '';

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType$_detail: $message');

    if (cause != null) {
      buffer.write(' (caused by $cause)');
    }

    return buffer.toString();
  }
}

/// The request reached the server and came back with a failing status.
sealed class HttpException extends AppException {
  const HttpException({
    required super.message,
    required this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int statusCode;

  @override
  String get _detail => '($statusCode)';
}

/// A 4xx: the request was wrong, and the backend usually says how.
final class ClientException extends HttpException {
  const ClientException({
    required super.message,
    required super.statusCode,
    this.fieldErrors = const [],
    super.cause,
    super.stackTrace,
  });

  /// Field-level messages from the backend's `ProblemDetail.errors`.
  final List<String> fieldErrors;

  @override
  String get message => fieldErrors.isEmpty
      ? super.message
      : ([super.message, ...fieldErrors]).join('\n');
}

/// A 5xx, or a status we have no better name for.
final class ServerException extends HttpException {
  const ServerException({
    required super.message,
    required super.statusCode,
    super.cause,
    super.stackTrace,
  });
}

/// The request never produced a response: no connectivity, timeout, bad TLS.
final class NetworkException extends AppException {
  const NetworkException({
    super.message =
        'Network error. Please check your connection and try again.',
    super.cause,
    super.stackTrace,
  });
}

/// The caller cancelled the request.
///
/// Almost always the app's own doing — a screen was popped, a search was
/// superseded — so this is the one failure UI should usually ignore.
final class CancelledException extends AppException {
  const CancelledException({
    super.message = 'The request was cancelled.',
    super.cause,
    super.stackTrace,
  });
}

/// The response arrived but did not look the way we expected.
final class ParsingException extends AppException {
  const ParsingException({
    super.message = 'Failed to parse the response.',
    super.cause,
    super.stackTrace,
  });
}

/// Something failed that we have no mapping for.
///
/// Deliberately not a [ServerException]: calling a local `TypeError` a server
/// error sends whoever reads the crash report to the wrong codebase.
final class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'Unexpected error. Please try again.',
    super.cause,
    super.stackTrace,
  });
}
