import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'features/auth/view_models/auth_view_model.dart';
import 'features/auth/views/login_view.dart';
import 'features/dashboard/views/dashboard_view.dart';

/// Application router with auth-redirect guard.
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authVm = context.read<AuthViewModel>();
    final isLoggedIn = authVm.isAuthenticated;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoginRoute) return '/login';
    if (isLoggedIn && isLoginRoute) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginView()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardView()),
  ],
);
