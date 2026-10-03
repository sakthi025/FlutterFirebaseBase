/// Standardized generic response wrapper for API calls.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  factory ApiResponse.success(T data, {int? statusCode}) => ApiResponse(
        success: true,
        data: data,
        statusCode: statusCode ?? 200,
      );

  factory ApiResponse.failure(String message, {int? statusCode, T? data}) =>
      ApiResponse(
        success: false,
        message: message,
        statusCode: statusCode,
        data: data,
      );
}
