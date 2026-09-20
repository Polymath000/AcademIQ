import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
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
        child: CircularProgressIndicator(color: AppColors.brandPurple),
      );
    }

    final profile = settingsState.profile;
    final semesters = homeState.semesters;

    return BlocConsumer<AiAdvisorCubit, AiAdvisorState>(
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
        if (state is AiAdvisorInitial || state is AiAdvisorError) {
          return IntialAIPage(profile: profile, semesters: semesters);
        }

        if (state is AiAdvisorLoading) {
          return LoadingAIPage();
        }

        if (state is AiAdvisorLoaded) {
          return AIResponsePage(analysisResult: state.analysisResult);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
