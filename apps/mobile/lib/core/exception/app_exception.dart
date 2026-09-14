sealed class AppException implements Exception {
  const AppException({required this.message});

  final String message;
}

final class NetworkException extends AppException {
  const NetworkException({
    super.message =
        'Network error. Please check your connection and try again.',
  });
}

final class ClientException extends AppException {
  const ClientException({
    required super.message,
    required this.statusCode,
    required this.code,
  });

  final int statusCode;
  final String code;
}

final class ServerException extends AppException {
  const ServerException({
    required super.message,
    required this.statusCode,
    required this.code,
  });

  final int statusCode;
  final String code;
}

final class ParsingException extends AppException {
  const ParsingException({
    super.message = 'Failed to parse the response.',
    this.cause,
  });

  final Object? cause;
}
