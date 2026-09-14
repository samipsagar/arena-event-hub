import 'package:dio/dio.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/network/problem_detail.dart';

/// Shown instead of a 5xx body, which is never ours to trust.
const _serverFailureMessage =
    'Something went wrong on our side. Please try again.';

/// Shown for a 4xx the backend did not explain.
const _clientFailureMessage = 'The request could not be completed.';

/// Translates a failing HTTP response into an [AppException].
///
/// The backend answers errors with RFC 9457 problem documents
/// (`application/problem+json`), whose `detail` is written for a person to
/// read — "Participant limit 5 is below the 8 already registered". That text
/// is worth far more than a generic string, so 4xx responses surface it.
AppException mapErrorResponse(
  Response<dynamic> response, {
  Object? cause,
  StackTrace? stackTrace,
}) {
  final statusCode = response.statusCode ?? 500;

  if (statusCode >= 400 && statusCode < 500) {
    final problem = ProblemDetail.fromJson(response.data);

    return ClientException(
      statusCode: statusCode,
      message: problem?.detail ?? _clientFailureMessage,
      fieldErrors: problem?.errors ?? const [],
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  // 5xx, or a non-2xx we have no better name for (a redirect we were told not
  // to follow, say). Report the status the server actually sent rather than
  // inventing a 500, and keep the body out of the user-facing message: on a
  // 5xx it is either the backend's own generic text or a proxy's error page.
  return ServerException(
    statusCode: statusCode,
    message: _serverFailureMessage,
    cause: cause,
    stackTrace: stackTrace,
  );
}

/// Translates a [DioException] into an [AppException].
AppException mapDioException(DioException error) {
  final response = error.response;

  if (response != null) {
    return mapErrorResponse(
      response,
      cause: error,
      stackTrace: error.stackTrace,
    );
  }

  // No response at all: the failure happened below HTTP.
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => NetworkException(
      message: 'Request timed out.',
      cause: error,
      stackTrace: error.stackTrace,
    ),

    DioExceptionType.connectionError => NetworkException(
      message: 'Unable to connect to the server.',
      cause: error,
      stackTrace: error.stackTrace,
    ),

    DioExceptionType.badCertificate => NetworkException(
      message: "The server's security certificate could not be verified.",
      cause: error,
      stackTrace: error.stackTrace,
    ),

    DioExceptionType.cancel => CancelledException(
      cause: error,
      stackTrace: error.stackTrace,
    ),

    DioExceptionType.badResponse || DioExceptionType.unknown =>
      NetworkException(cause: error, stackTrace: error.stackTrace),
  };
}

/// Normalises anything caught above the network layer into an [AppException].
///
/// Use this in repositories and notifiers so callers only ever switch over the
/// sealed hierarchy.
AppException toAppException(Object error, [StackTrace? stackTrace]) {
  if (error is AppException) {
    return error;
  }

  if (error is DioException) {
    final mapped = error.error;

    // The interceptor normally attaches this on the way out.
    return mapped is AppException ? mapped : mapDioException(error);
  }

  return UnexpectedException(cause: error, stackTrace: stackTrace);
}
