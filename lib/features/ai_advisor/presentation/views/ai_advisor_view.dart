import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

class AiAdvisorView extends StatelessWidget {
  const AiAdvisorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: Text('AI Advisor', style: AppTextStyles.h2),
      ),
    );
  }
}
