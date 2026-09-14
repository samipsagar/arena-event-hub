import 'package:dio/dio.dart';
import 'package:sports/core/exception/app_exception.dart';

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
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

  Future<T?> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
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

  Future<T?> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
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

  Future<T?> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
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

  Future<T?> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
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

  Future<T?> _request<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data)? parser,
  ) async {
    final response = await request();

    if (parser == null) {
      return null;
    }

    try {
      return parser(response.data);
    } catch (error) {
      throw ParsingException(
        message: 'Failed to parse server response.',
        cause: error,
      );
    }
  }
}
