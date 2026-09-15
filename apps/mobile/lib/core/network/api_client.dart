import 'package:dio/dio.dart';
import 'package:sports/core/exception/app_exception.dart';

/// Thin typed wrapper over Dio.
///
/// Every call takes a [parser], so the response type is decided at the call
/// site rather than left as a nullable the caller has to second-guess.
///
/// Failures leave here as [AppException]s and nothing else. `ErrorInterceptor`
/// does the mapping but has to hand the result back on `DioException.error`,
/// because that is the only channel Dio gives an interceptor; this class
/// unwraps it so Dio stops at the network layer.
class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    required T Function(dynamic data) parser,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> post<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> put<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> patch<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> delete<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> _request<T>(
    Future<Response<dynamic>> Function() send,
    T Function(dynamic data) parser,
  ) async {
    final Response<dynamic> response;

    try {
      response = await send();
    } on DioException catch (error, stackTrace) {
      final cause = error.error;

      if (cause is AppException) {
        throw cause;
      }

      // An interceptor was added after ErrorInterceptor, or Dio failed before
      // the chain ran. Neither should happen, so say so rather than guess.
      throw UnexpectedException(cause: error, stackTrace: stackTrace);
    }

    try {
      return parser(response.data);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      throw ParsingException(
        message: 'Failed to parse server response.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
