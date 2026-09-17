import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login_params.dart';
import '../../data/models/register_params.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required this._authRepository}) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    final result = await _authRepository.getCurrentUser();
    result.when(
      success: (user) {
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
      failure: (error) => emit(AuthError(error.message)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final params = LoginParams(email: email, password: password);
    final result = await _authRepository.login(params);
    result.when(
      success: (user) => emit(AuthSuccess(user)),
      failure: (error) => emit(AuthError(error.message)),
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    final params = RegisterParams(name: name, email: email, password: password);
    final result = await _authRepository.register(params);
    result.when(
      success: (user) => emit(AuthSuccess(user)),
      failure: (error) => emit(AuthError(error.message)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
