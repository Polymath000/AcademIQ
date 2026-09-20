import 'package:gpa_calculator/core/widgets/orbital_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/core/widgets/app_snack_bar.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/cubit/ai_advisor_cubit.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/cubit/ai_advisor_state.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/widgets/a_i_response_page.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/widgets/intial_a_i_page.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/widgets/loading_a_i_page.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_cubit.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_state.dart';
import 'package:gpa_calculator/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:gpa_calculator/features/settings/presentation/cubit/settings_state.dart';

class AiAdvisorViewBody extends StatelessWidget {
  const AiAdvisorViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final homeState = context.watch<HomeCubit>().state;

    if (settingsState is! SettingsLoaded || homeState is! HomeLoaded) {
      return const Center(
        child: OrbitalLoadingIndicator(size: 80),
      );
    }

    final profile = settingsState.profile;
    final semesters = homeState.semesters;

    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: BlocConsumer<AiAdvisorCubit, AiAdvisorState>(
      listener: (context, state) {
        if (state is AiAdvisorError) {
          AppSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        } else if (state is AiAdvisorLoaded) {
          context.read<SettingsCubit>().loadSettings();
        }
      },
      builder: (context, state) {
        Widget child = const SizedBox.shrink();

        if (state is AiAdvisorInitial || state is AiAdvisorError) {
          child = IntialAIPage(
            key: const ValueKey('initial'),
            profile: profile,
            semesters: semesters,
          );
        } else if (state is AiAdvisorLoading) {
          child = const LoadingAIPage(key: ValueKey('loading'));
        } else if (state is AiAdvisorLoaded) {
          child = AIResponsePage(
            key: const ValueKey('response'),
            analysisResult: state.analysisResult,
            profile: profile,
            semesters: semesters,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    ),
    );
  }
}
