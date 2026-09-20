import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/onboarding_model.dart';
import '../../../../config/theme/app_icons.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<OnboardingItem> items = const [
    OnboardingItem(
      title: 'Effortless GPA Tracking',
      description: 'Log your semester courses, credit hours, and grades with ease. Keep your academic goals on target.',
      icon: AppIcons.relationArrow,
    ),
    OnboardingItem(
      title: 'AI Academic Advisor',
      description: 'Get instant AI analysis powered by Groq Cloud to boost your grades and optimize course loads.',
      icon: AppIcons.chatBubble,
    ),
    OnboardingItem(
      title: 'Cloud Sync & History',
      description: 'Securely sync your academic data across devices using Firebase Cloud storage.',
      icon: AppIcons.history,
    ),
  ];

  void onPageChanged(int index) {
    _currentIndex = index;
    emit(OnboardingPageChanged(index));
  }

  void completeOnboarding() {
    emit(OnboardingCompletedState());
  }
}
