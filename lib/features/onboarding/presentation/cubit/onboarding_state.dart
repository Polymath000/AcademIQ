import 'package:flutter/foundation.dart';

@immutable
sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingPageChanged extends OnboardingState {
  final int pageIndex;
  const OnboardingPageChanged(this.pageIndex);
}

final class OnboardingCompletedState extends OnboardingState {}
