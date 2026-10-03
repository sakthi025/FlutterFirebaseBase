/// Central repository of all backend API endpoints and routing paths.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL is typically configured per flavor/environment (dev, staging, prod)
  static const String devBaseUrl = 'https://api-dev.example.com/v1';
  static const String stagingBaseUrl = 'https://api-staging.example.com/v1';
  static const String prodBaseUrl = 'https://api.example.com/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String userProfile = '/auth/me';

  // Multi-app feature endpoints
  static const String appConfig = '/config';
  static const String notifications = '/notifications';
  static const String syncData = '/sync';
}
