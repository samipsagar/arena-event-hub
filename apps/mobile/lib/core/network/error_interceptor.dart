import 'package:dio/dio.dart';
import 'package:sports/core/exception/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final statusCode = response.statusCode ?? 500;

    if (statusCode >= 200 && statusCode < 300) {
      handler.next(response);
      return;
    }

    final exception = _mapResponseException(response);

    handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: exception,
      ),
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Already converted to our application exception.
    if (err.error is AppException) {
      handler.next(err);
      return;
    }

    final exception = _mapError(err);

    handler.next(err.copyWith(error: exception));
  }

  AppException _mapResponseException(Response<dynamic> response) {
    final statusCode = response.statusCode ?? 500;

    if (statusCode >= 500) {
      return ServerException(
        statusCode: statusCode,
        code: 'server.error',
        message: 'Something went wrong on our side. Please try again.',
      );
    }

    if (statusCode >= 400) {
      return ClientException(
        statusCode: statusCode,
        code: 'client.error',
        message: 'The request could not be completed.',
      );
    }

    return const ServerException(
      statusCode: 500,
      code: 'internal.error',
      message: 'Unexpected error. Please try again.',
    );
  }

  AppException _mapError(DioException error) {
    // No HTTP response = transport/network failure.
    if (error.response == null) {
      return _mapNetworkException(error);
    }

    // Dio gave us an HTTP response but routed it through onError.
    return _mapResponseException(error.response!);
  }

  NetworkException _mapNetworkException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const NetworkException(
        message: 'Request timed out.',
      ),

      DioExceptionType.connectionError => const NetworkException(
        message: 'Unable to connect to the server.',
      ),

      _ => const NetworkException(),
    };
  }
}

AppException toAppException(Object error) {
  if (error is AppException) {
    return error;
  }

  if (error is DioException && error.error is AppException) {
    return error.error! as AppException;
  }

  return const ServerException(
    statusCode: 500,
    code: 'internal.error',
    message: 'Unexpected error. Please try again.',
  );
}
