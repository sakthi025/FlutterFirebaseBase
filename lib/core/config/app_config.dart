enum Environment { dev, staging, prod }

/// Central configuration container holding active environment constants and feature flags.
class AppConfig {
  AppConfig._({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.enablePerformanceMonitoring,
  });

  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableCrashlytics;
  final bool enablePerformanceMonitoring;

  static late AppConfig current;

  static void initialize({
    required Environment environment,
    required String appName,
    required String apiBaseUrl,
    bool enableLogging = true,
    bool enableCrashlytics = true,
    bool enablePerformanceMonitoring = true,
  }) {
    current = AppConfig._(
      environment: environment,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      enableCrashlytics: enableCrashlytics,
      enablePerformanceMonitoring: enablePerformanceMonitoring,
    );
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
