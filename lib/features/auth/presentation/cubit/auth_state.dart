import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

final class AuthUnauthenticated extends AuthState {}
