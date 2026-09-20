import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';
import 'package:gpa_calculator/core/widgets/app_snack_bar.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/settings/data/models/profile_model.dart';
import '../cubit/ai_advisor_cubit.dart';

class AIResponsePage extends StatelessWidget {
  const AIResponsePage({
    super.key,
    required this.analysisResult,
    required this.profile,
    required this.semesters,
  });

  final String analysisResult;
  final ProfileModel profile;
  final List<SemesterEntity> semesters;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.read<AiAdvisorCubit>().reset(),
                tooltip: 'Back',
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: AppColors.textMuted),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: analysisResult));
                  AppSnackBar.show(
                    context,
                    message: 'Copied to clipboard!',
                    type: SnackBarType.success,
                  );
                },
                tooltip: 'Copy',
              ),
            ],
          ),
        ),
        Expanded(
          child: Markdown(
            data: analysisResult,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
            styleSheet: MarkdownStyleSheet(
              h1: AppTextStyles.h2,
              h2: AppTextStyles.h3,
              p: AppTextStyles.bodyMedium,
              listBullet: const TextStyle(color: AppColors.brandAccent),
            ),
          ),
        ),
      ],
    );
  }
}
