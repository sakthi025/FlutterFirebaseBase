import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/auth/auth_service.dart';
import '../core/di/service_locator.dart';
import '../core/logging/app_logger.dart';
import '../ui/core/theme/app_theme.dart';
import '../ui/features/auth/view_models/auth_view_model.dart';
import 'router.dart';

/// Root application widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.info('App widget initialised');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authService: sl<AuthService>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'FlutterFirebaseBase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
