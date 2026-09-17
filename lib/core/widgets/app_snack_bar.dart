import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

/// The type of snack bar message.
enum SnackBarType { error, success, info }

/// A custom themed snack bar that matches AcademIQ's dark glassmorphic UI.
///
/// Usage:
/// ```dart
/// AppSnackBar.show(context, message: 'Login failed', type: SnackBarType.error);
/// AppSnackBar.show(context, message: 'Welcome back!', type: SnackBarType.success);
/// AppSnackBar.show(context, message: 'Check your email', type: SnackBarType.info);
/// ```
class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_build(message, type, duration));
  }

  static SnackBar _build(String message, SnackBarType type, Duration duration) {
    final config = _configFor(type);

    return SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1525),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: config.color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: config.color.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Colored icon ──
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                config.icon,
                color: config.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // ── Message ──
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.title,
                    style: AppTextStyles.label.copyWith(
                      color: config.color,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static _SnackBarConfig _configFor(SnackBarType type) {
    return switch (type) {
      SnackBarType.error => const _SnackBarConfig(
          color: AppColors.gradeWeak,
          icon: Icons.warning_amber_rounded,
          title: 'ERROR',
        ),
      SnackBarType.success => const _SnackBarConfig(
          color: AppColors.brandAccent,
          icon: Icons.check_circle_outline_rounded,
          title: 'SUCCESS',
        ),
      SnackBarType.info => const _SnackBarConfig(
          color: AppColors.brandPurple,
          icon: Icons.info_outline_rounded,
          title: 'INFO',
        ),
    };
  }
}

class _SnackBarConfig {
  final Color color;
  final IconData icon;
  final String title;

  const _SnackBarConfig({
    required this.color,
    required this.icon,
    required this.title,
  });
}
