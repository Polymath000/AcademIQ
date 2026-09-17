import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/routes/app_routes.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';

class RegisterLink extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account?', style: AppTextStyles.bodyMedium),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.register);
          },
          child: Text('Register', style: AppTextStyles.link),
        ),
      ],
    );
  }
}
