import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/auth_failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserEntity> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserEntity(
        uid: result.user!.uid,
        email: result.user!.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_getMessage(e.code));
    } catch (_) {
      throw AuthFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserEntity(
        uid: result.user!.uid,
        email: result.user!.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_getMessage(e.code));
    } catch (_) {
      throw AuthFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try signing in.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
