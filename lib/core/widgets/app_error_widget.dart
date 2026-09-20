import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../config/theme/app_icons.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                AppIcons.errorWarning,
                color: Colors.redAccent,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? "There's an error please try again later",
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: AppButton(
                  text: 'Try Again',
                  onPressed: onRetry!,
                  backgroundColor: AppColors.brandAccent,
                  foregroundColor: AppColors.bgDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
