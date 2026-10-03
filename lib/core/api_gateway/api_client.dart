import 'package:dio/dio.dart';
import '../auth/auth_service.dart';
import '../logging/app_logger.dart';
import 'api_exceptions.dart';
import 'api_response.dart';

/// Reusable API Gateway client using [Dio].
/// Provides interceptors for auth token injection, logging, error handling, and timeout configurations.
class ApiClient {
  ApiClient({
    required String baseUrl,
    AuthService? authService,
    Dio? dio,
  })  : _baseUrl = baseUrl,
        _authService = authService,
        _dio = dio ?? Dio() {
    _initDio();
  }

  final String _baseUrl;
  final AuthService? _authService;
  final Dio _dio;

  Dio get dio => _dio;

  void _initDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Auth & Logging Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Inject Firebase Auth ID token if signed in
          if (_authService != null && _authService.currentUser != null) {
            final token = await _authService.currentUser!.getIdToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          AppLogger.instance.debug('API Request: [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.instance.debug(
            'API Response: [${response.statusCode}] ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          AppLogger.instance.error(
            'API Error: [${error.response?.statusCode}] ${error.requestOptions.uri} - ${error.message}',
            error,
            error.stackTrace,
          );
          return handler.next(error);
        },
      ),
    );
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      final mappedData = fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(mappedData, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final mappedData = fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(mappedData, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final mappedData = fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(mappedData, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final mappedData = fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(mappedData, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Translates DioException to application-level ApiException
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        final message = error.response?.statusMessage ?? 'Server response error';
        if (code == 401) {
          return UnauthorizedException(message: message);
        } else if (code == 403) {
          return ForbiddenException(message: message);
        } else if (code == 404) {
          return NotFoundException(message: message);
        } else if (code != null && code >= 500) {
          return ServerException(message: message, statusCode: code);
        }
        return ApiException(message: message, statusCode: code, errorDetails: error.response?.data);
      case DioExceptionType.connectionError:
        return NetworkException();
      default:
        return ApiException(message: error.message ?? 'Unknown network error');
    }
  }
}
