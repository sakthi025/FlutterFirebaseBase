import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/logging/app_logger.dart';

/// ViewModel managing authentication state and login/register actions.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthService authService})
      : _authService = authService {
    _init();
  }

  final AuthService _authService;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _currentUser = _authService.currentUser;
    _authService.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      _currentUser = credential.user;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.instance.error('SignIn error', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final credential = await _authService.registerWithEmail(
        email: email,
        password: password,
      );
      _currentUser = credential.user;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.instance.error('Register error', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    try {
      final credential = await _authService.signInWithGoogle();
      _currentUser = credential.user;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.instance.error('Google SignIn error', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
