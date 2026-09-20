import '../../../../config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CgpaCircularDisplay extends StatelessWidget {
  final double cgpa;
  final double maxGpa;
  final int totalCredits;

  const CgpaCircularDisplay({
    super.key,
    required this.cgpa,
    required this.maxGpa,
    required this.totalCredits,
  });

  @override
  Widget build(BuildContext context) {
    // Prevent division by zero if grading scale is completely empty or zero
    final double safeMax = maxGpa > 0 ? maxGpa : 4.0;
    final double progress = cgpa / safeMax;

    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.bgDark.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 15,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CGPA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  cgpa.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Out of ${safeMax.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalCredits Credits',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
