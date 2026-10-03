import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_base/core/auth/auth_service.dart';
import 'package:flutter_firebase_base/core/config/app_config.dart';
import 'package:flutter_firebase_base/core/di/service_locator.dart';
import 'package:flutter_firebase_base/core/database/firestore_service.dart';
import 'package:flutter_firebase_base/core/database/storage_service.dart';
import 'package:flutter_firebase_base/core/database/functions_service.dart';
import 'package:flutter_firebase_base/core/api_gateway/api_client.dart';
import '../../auth/view_models/auth_view_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;
    final config = sl<AppConfig>();

    return Scaffold(
      appBar: AppBar(
        title: Text(config.appName),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authVm.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          (user?.email?.isNotEmpty ?? false)
                              ? user!.email![0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'Authenticated User',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              user?.email ?? 'No email',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Environment:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Chip(
                        label: Text(config.environment.name.toUpperCase()),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Integrated Modules',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _ModuleStatusTile(
            title: 'Authentication Module',
            subtitle: 'Firebase Auth (Email, Google, Custom tokens)',
            icon: Icons.security,
            isReady: sl.isRegistered<AuthService>(),
          ),
          _ModuleStatusTile(
            title: 'Database Layer',
            subtitle: 'Cloud Firestore with CRUD, streams & batches',
            icon: Icons.storage,
            isReady: sl.isRegistered<FirestoreService>(),
          ),
          _ModuleStatusTile(
            title: 'Cloud Storage',
            subtitle: 'Firebase Storage for files & media uploads',
            icon: Icons.cloud_upload_outlined,
            isReady: sl.isRegistered<StorageService>(),
          ),
          _ModuleStatusTile(
            title: 'Cloud Functions Gateway',
            subtitle: 'Firebase HTTPS callable backend functions',
            icon: Icons.code,
            isReady: sl.isRegistered<FunctionsService>(),
          ),
          _ModuleStatusTile(
            title: 'REST API Gateway',
            subtitle: 'Dio client with auth interceptors & typed errors',
            icon: Icons.http,
            isReady: sl.isRegistered<ApiClient>(),
          ),
          _ModuleStatusTile(
            title: 'Logging & Monitoring',
            subtitle: 'AppLogger, Crashlytics, and Performance traces',
            icon: Icons.monitor_heart_outlined,
            isReady: true,
          ),
        ],
      ),
    );
  }
}

class _ModuleStatusTile extends StatelessWidget {
  const _ModuleStatusTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isReady,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(
          isReady ? Icons.check_circle : Icons.warning_amber_rounded,
          color: isReady ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
