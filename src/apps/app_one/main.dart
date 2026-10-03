import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_base/firebase_options.dart';
import 'package:flutter_firebase_base/ui/app.dart';
import 'package:flutter_firebase_base/core/config/app_config.dart';
import 'package:flutter_firebase_base/core/di/service_locator.dart';
import 'package:flutter_firebase_base/core/logging/app_logger.dart';

/// Entrypoint for App One (e.g., Customer / Consumer Mobile App).
/// Run using: flutter run -t src/apps/app_one/main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Set App-specific Configuration & Service Locator
  AppConfig.initialize(
    environment: Environment.dev,
    appName: 'Consumer App (App One)',
    apiBaseUrl: 'https://api-app1.example.com/v1',
  );

  await setupServiceLocator(environment: Environment.dev);

  AppLogger.instance.info('App One launched successfully.');
  runApp(const App());
}
