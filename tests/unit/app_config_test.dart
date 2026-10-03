import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_base/core/config/app_config.dart';

void main() {
  group('AppConfig Tests', () {
    test('initializes with dev environment correctly', () {
      AppConfig.initialize(
        environment: Environment.dev,
        appName: 'Base Dev',
        apiBaseUrl: 'https://api-dev.test',
        enableLogging: true,
      );

      expect(AppConfig.current.environment, equals(Environment.dev));
      expect(AppConfig.current.isDev, isTrue);
      expect(AppConfig.current.isProd, isFalse);
      expect(AppConfig.current.appName, equals('Base Dev'));
      expect(AppConfig.current.apiBaseUrl, equals('https://api-dev.test'));
    });

    test('initializes with prod environment correctly', () {
      AppConfig.initialize(
        environment: Environment.prod,
        appName: 'Base Prod',
        apiBaseUrl: 'https://api.test',
        enableLogging: false,
      );

      expect(AppConfig.current.isProd, isTrue);
      expect(AppConfig.current.isDev, isFalse);
      expect(AppConfig.current.enableLogging, isFalse);
    });
  });
}
