import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/core/config/app_config.dart';
import 'package:sports/core/network/api_client.dart';
import 'package:sports/core/network/dio_factory.dart';

/// Single configured Dio instance for the app.
final dioProvider = Provider<Dio>((ref) {
  return createAppDio(baseUrl: ApiConfig.baseUrl);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
