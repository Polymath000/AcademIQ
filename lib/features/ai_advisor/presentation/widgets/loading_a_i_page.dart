import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';
import 'package:gpa_calculator/core/widgets/orbital_loading_indicator.dart';

class LoadingAIPage extends StatelessWidget {
  const LoadingAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const OrbitalLoadingIndicator(size: 100),
          const SizedBox(height: 32),
          Text('Analyzing your grades...', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
