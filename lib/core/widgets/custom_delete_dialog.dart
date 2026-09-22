import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

void showCustomDeleteDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onDelete,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.navBarBg,
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      content: Text(
        content,
        style: const TextStyle(color: AppColors.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error.withValues(alpha: 0.9),
          ),
          onPressed: () {
            onDelete();
            Navigator.pop(ctx);
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ],
    ),
  );
}
