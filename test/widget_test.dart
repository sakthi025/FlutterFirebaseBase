import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_base/ui/core/theme/app_theme.dart';
import 'package:flutter_firebase_base/ui/features/auth/views/login_view.dart';
import 'package:flutter_firebase_base/ui/features/auth/view_models/auth_view_model.dart';
import 'package:flutter_firebase_base/core/auth/auth_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('LoginView renders branding, fields and action buttons', (tester) async {
    final mockAuth = MockFirebaseAuth();
    final authService = AuthService(auth: mockAuth);
    final authViewModel = AuthViewModel(authService: authService);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ChangeNotifierProvider<AuthViewModel>.value(
          value: authViewModel,
          child: const LoginView(),
        ),
      ),
    );

    // Verify Title Branding
    expect(find.text('FlutterFirebaseBase'), findsOneWidget);

    // Verify Inputs
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
