import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/core/config/app_config.dart';
import 'package:sports/core/network/api_client.dart';
import 'package:sports/core/network/error_interceptor.dart';

/// Single configured Dio instance for the app.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: Headers.jsonContentType,
      // We translate non-2xx ourselves, so Dio should hand them to us intact.
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  dio.interceptors.add(ErrorInterceptor());
  // TODO: Add other interceptors like logging, auth, etc.

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
