import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../logging/app_logger.dart';

/// Monitoring service for crash reporting and non-fatal error captures via [FirebaseCrashlytics].
class CrashlyticsService {
  CrashlyticsService({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;

  /// Initialize Crashlytics hooks for Flutter errors and platform errors
  Future<void> initialize() async {
    // Only enable collection in non-debug mode by default, or as configured
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      _crashlytics.recordFlutterFatalError(errorDetails);
      AppLogger.instance.fatal(
        'Flutter Fatal Error: ${errorDetails.exceptionAsString()}',
        errorDetails.exception,
        errorDetails.stack,
      );
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      AppLogger.instance.fatal('Platform Uncaught Error', error, stack);
      return true;
    };

    AppLogger.instance.info('CrashlyticsService initialized.');
  }

  /// Record non-fatal exception
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    AppLogger.instance.error('Recording error to Crashlytics: $reason', exception, stack);
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Set user ID to associate crashes with a specific user
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Set custom attributes
  Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Log breadcrumb message
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
}
