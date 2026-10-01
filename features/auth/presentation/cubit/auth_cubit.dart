import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await repository.signUp(email.trim(), password);
      emit(AuthSuccess(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await repository.signIn(email.trim(), password);
      emit(AuthSuccess(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    emit(AuthLoggedOut());
  }
}
