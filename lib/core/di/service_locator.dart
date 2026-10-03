import 'package:get_it/get_it.dart';
import '../api_gateway/api_client.dart';
import '../auth/auth_service.dart';
import '../config/app_config.dart';
import '../database/firestore_service.dart';
import '../database/functions_service.dart';
import '../database/storage_service.dart';
import '../logging/app_logger.dart';
import '../monitoring/crashlytics_service.dart';
import '../monitoring/performance_service.dart';
import '../../data/repositories/auth_repository.dart';

final GetIt sl = GetIt.instance;

/// Sets up the central service locator (Dependency Injection).
Future<void> setupServiceLocator({
  Environment environment = Environment.dev,
}) async {
  AppLogger.instance.info('Setting up service locator for $environment');

  // Initialize App Configuration if not already initialized
  if (!sl.isRegistered<AppConfig>()) {
    AppConfig.initialize(
      environment: environment,
      appName: 'FlutterFirebaseBase',
      apiBaseUrl: switch (environment) {
        Environment.dev => 'https://api-dev.example.com/v1',
        Environment.staging => 'https://api-staging.example.com/v1',
        Environment.prod => 'https://api.example.com/v1',
      },
    );
    sl.registerSingleton<AppConfig>(AppConfig.current);
  }

  // Core Services
  if (!sl.isRegistered<AuthService>()) {
    sl.registerLazySingleton<AuthService>(() => AuthService());
  }
  if (!sl.isRegistered<FirestoreService>()) {
    sl.registerLazySingleton<FirestoreService>(() => FirestoreService());
  }
  if (!sl.isRegistered<StorageService>()) {
    sl.registerLazySingleton<StorageService>(() => StorageService());
  }
  if (!sl.isRegistered<FunctionsService>()) {
    sl.registerLazySingleton<FunctionsService>(() => FunctionsService());
  }
  if (!sl.isRegistered<CrashlyticsService>()) {
    sl.registerLazySingleton<CrashlyticsService>(() => CrashlyticsService());
  }
  if (!sl.isRegistered<PerformanceService>()) {
    sl.registerLazySingleton<PerformanceService>(() => PerformanceService());
  }

  // API Gateway Client
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: AppConfig.current.apiBaseUrl,
        authService: sl<AuthService>(),
      ),
    );
  }

  // Repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        authService: sl<AuthService>(),
        firestoreService: sl<FirestoreService>(),
      ),
    );
  }

  // Monitoring init
  if (AppConfig.current.enableCrashlytics) {
    try {
      await sl<CrashlyticsService>().initialize();
    } catch (e) {
      AppLogger.instance.warning('Crashlytics initialization skipped or not supported on this platform: $e');
    }
  }

  AppLogger.instance.info('Service locator initialization completed.');
}
