/// Standard API exceptions thrown across API Gateway layers.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  final String message;
  final int? statusCode;
  final dynamic errorDetails;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, details: $errorDetails)';
}

class NetworkException extends ApiException {
  NetworkException({super.message = 'No internet connection or network failure.'})
      : super(statusCode: null);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.message = 'Unauthorized request. Please re-login.'})
      : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException({super.message = 'Access denied for requested resource.'})
      : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException({super.message = 'Resource not found.'})
      : super(statusCode: 404);
}

class ServerException extends ApiException {
  ServerException({super.message = 'Internal server error occurred.', int statusCode = 500})
      : super(statusCode: statusCode);
}

class TimeoutException extends ApiException {
  TimeoutException({super.message = 'Request timed out.'})
      : super(statusCode: 408);
}
