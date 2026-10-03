import 'package:firebase_auth/firebase_auth.dart';
import '../../core/auth/auth_service.dart';
import '../../core/database/firestore_service.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/models/result.dart';
import '../../domain/models/user_model.dart';

/// Repository abstracting Auth and User Profile persistence in Firestore.
class AuthRepository {
  AuthRepository({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService;

  final AuthService _authService;
  final FirestoreService _firestoreService;

  static const String _usersCollection = 'users';

  /// Stream mapping Firebase User to Domain UserModel
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      if (user == null) return null;
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }

  /// Sign In with Email and sync profile
  Future<Result<UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const Failure('Sign in succeeded but user is null');
      }

      final profile = await _fetchOrCreateProfile(user);
      return Success(profile);
    } catch (e, stack) {
      AppLogger.instance.error('AuthRepository: signInWithEmail failed', e, stack);
      return Failure(e.toString(), e);
    }
  }

  /// Register new user and persist document in Firestore
  Future<Result<UserModel>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _authService.registerWithEmail(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const Failure('Registration succeeded but user is null');
      }

      final model = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName ?? user.displayName,
        createdAt: DateTime.now(),
      );

      await _firestoreService.setDocument(
        collectionPath: _usersCollection,
        docId: model.uid,
        data: model.toJson(),
      );

      return Success(model);
    } catch (e, stack) {
      AppLogger.instance.error('AuthRepository: registerWithEmail failed', e, stack);
      return Failure(e.toString(), e);
    }
  }

  /// Sign In with Google
  Future<Result<UserModel>> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      final user = credential.user;
      if (user == null) {
        return const Failure('Google sign in succeeded but user is null');
      }
      final profile = await _fetchOrCreateProfile(user);
      return Success(profile);
    } catch (e, stack) {
      AppLogger.instance.error('AuthRepository: signInWithGoogle failed', e, stack);
      return Failure(e.toString(), e);
    }
  }

  /// Sign Out
  Future<Result<void>> signOut() async {
    try {
      await _authService.signOut();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e);
    }
  }

  /// Helper to fetch existing profile or create it if missing
  Future<UserModel> _fetchOrCreateProfile(User user) async {
    final doc = await _firestoreService.getDocument(
      collectionPath: _usersCollection,
      docId: user.uid,
    );

    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!, doc.id);
    }

    final newModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );

    await _firestoreService.setDocument(
      collectionPath: _usersCollection,
      docId: user.uid,
      data: newModel.toJson(),
    );

    return newModel;
  }
}
