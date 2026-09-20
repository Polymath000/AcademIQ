import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/cubit/ai_advisor_cubit.dart';

class AIResponsePage extends StatelessWidget {
  const AIResponsePage({super.key, required this.analysisResult});
  final String analysisResult;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Markdown(
            data: analysisResult,
            styleSheet: MarkdownStyleSheet(
              h1: AppTextStyles.h2,
              h2: AppTextStyles.h3,
              p: AppTextStyles.bodyMedium,
              listBullet: const TextStyle(color: AppColors.brandAccent),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.navBarBg,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceDark,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => context.read<AiAdvisorCubit>().reset(),
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Refresh / Ask Again',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
