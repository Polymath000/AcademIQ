import '../../../../config/theme/app_colors.dart';

import 'package:flutter/material.dart';

class CgpaDashboardCard extends StatelessWidget {
  final double cgpa;
  final double maxGpa;
  final int totalCredits;

  const CgpaDashboardCard({
    super.key,
    required this.cgpa,
    required this.maxGpa,
    required this.totalCredits,
  });

  String _getStandingLabel() {
    if (maxGpa == 0) return 'No Standing';
    final percentage = cgpa / maxGpa;
    if (percentage >= 0.875) return "Dean's List"; // roughly 3.5/4.0
    if (percentage >= 0.75) return "Honor Roll";
    if (percentage >= 0.5) return "Good Standing";
    return "Academic Probation";
  }

  Color _getStandingColor() {
    if (maxGpa == 0) return AppColors.textMuted;
    final percentage = cgpa / maxGpa;
    if (percentage >= 0.875) return AppColors.statusExcellent; // Emerald
    if (percentage >= 0.75) return AppColors.statusGood; // Blue
    if (percentage >= 0.5) return AppColors.statusAverage; // Amber
    return AppColors.statusPoor; // Red
  }

  @override
  Widget build(BuildContext context) {
    final double safeMax = maxGpa > 0 ? maxGpa : 4.0;
    final double progress = cgpa / safeMax;
    final standingLabel = _getStandingLabel();
    final standingColor = _getStandingColor();
    final int percentInt = (progress * 100).clamp(0, 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AppColors.cardGradientStart, // Light top-left violet
            AppColors.cardGradientEnd, // Dark bottom-right violet
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CUMULATIVE GPA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cgpa.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 56,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: standingColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: standingColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: standingColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        standingLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: standingColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$totalCredits Total Credits',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Right Side Chart
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 10,
                    backgroundColor: AppColors.chartTrackBg.withValues(
                      alpha: 0.3,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.chartVibrant,
                    ), // Vibrant Violet
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentInt%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'of ${safeMax.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
