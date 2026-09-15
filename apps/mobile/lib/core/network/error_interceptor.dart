import 'package:dio/dio.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/network/error_mapper.dart';

/// Turns every Dio failure into an [AppException] before it leaves the
/// network layer.
///
/// Dio is configured to accept every status (see `createAppDio`), so failing
/// responses arrive here at [onResponse] and are rejected; [onError] catches
/// what never got a response at all.
class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      handler.next(response);
      return;
    }

    handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        // Not `unknown`: retry and logging interceptors classify on this.
        type: DioExceptionType.badResponse,
        error: mapErrorResponse(response),
      ),
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Already converted — either by onResponse above, or by an interceptor
    // that ran before this one.
    if (err.error is AppException) {
      handler.next(err);
      return;
    }

    handler.next(err.copyWith(error: mapDioException(err)));
  }
}
