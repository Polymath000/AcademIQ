import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/config/theme/app_icons.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/cubit/ai_advisor_cubit.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/settings/data/models/profile_model.dart';

class IntialAIPage extends StatelessWidget {
  const IntialAIPage({
    super.key,
    required this.profile,
    required this.semesters,
  });

  final ProfileModel profile;
  final List<SemesterEntity> semesters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.psychology,
              size: 80,
              color: AppColors.brandPurple.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 48),
            Text(
              'Get Personalized Academic Advice',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'AI Analyses Generated: ${profile.aiUsageCount}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.brandAccent,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPurple,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: (profile.isQuotaFinished)
                  ? null
                  : () => context.read<AiAdvisorCubit>().generateAnalysis(
                      profile,
                      semesters,
                    ),
              icon: const Icon(AppIcons.aiAdvisor),
              label: const Text(
                'Generate AI Analysis',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (profile.isQuotaFinished)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'You have reached your AI limit.',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
