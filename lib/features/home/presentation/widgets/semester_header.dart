import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';

class SemesterHeader extends StatelessWidget {
  final SemesterEntity semester;
  final double gpa;

  const SemesterHeader({super.key, required this.semester, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              semester.semester.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${semester.subjects.length} Courses',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              gpa.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPurpleLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${semester.totalCredits} Cr.',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}
