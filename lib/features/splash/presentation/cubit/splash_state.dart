import 'package:flutter/foundation.dart';

@immutable
sealed class SplashState {
  const SplashState();
}

final class SplashInitial extends SplashState {}

final class SplashLoading extends SplashState {}

final class SplashNavigateToOnboarding extends SplashState {}

final class SplashNavigateToLogin extends SplashState {}

final class SplashNavigateToHome extends SplashState {}
