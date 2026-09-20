import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';

class LoadingAIPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.brandPurple),
          const SizedBox(height: 24),
          Text('Analyzing your grades...', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
