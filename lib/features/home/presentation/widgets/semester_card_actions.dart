import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_cubit.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/show_add_subject_dialog.dart';

class SemesterCardActions extends StatelessWidget {
  final SemesterEntity semesterEntity;
  final HomeCubit cubit;

  const SemesterCardActions({
    super.key,
    required this.semesterEntity,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            onPressed: () =>
                showAddSubjectDialog(context, cubit, semesterEntity),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Course'),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Semester'),
                  content: const Text(
                    'Are you sure you want to delete this semester and all its subjects?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      onPressed: () {
                        cubit.deleteSemester(semesterEntity.semester.id);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
