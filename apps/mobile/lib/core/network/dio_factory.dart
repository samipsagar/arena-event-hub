import 'package:dio/dio.dart';
import 'package:sports/core/config/app_config.dart';
import 'package:sports/core/network/error_interceptor.dart';

/// Builds the app's Dio instance.
///
/// Separate from the provider so tests can build the real thing against a
/// fake adapter — the timeouts, the status handling and the interceptor chain
/// under test are the ones that ship.
Dio createAppDio({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: Headers.jsonContentType,
      // Hand every status to the interceptor chain so that exactly one place
      // decides what an HTTP failure means, instead of splitting that between
      // Dio's own threshold and ours.
      validateStatus: (_) => true,
    ),
  );

  // Keep ErrorInterceptor last. Response interceptors run in the order they
  // were added and this one rejects non-2xx responses, so anything added
  // after it would never see a failure. A logging or auth-refresh
  // interceptor therefore belongs above this line.
  // TODO: Add logging and auth interceptors here.
  dio.interceptors.add(ErrorInterceptor());

  return dio;
}
