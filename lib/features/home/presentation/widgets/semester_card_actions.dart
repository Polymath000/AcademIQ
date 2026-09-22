import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_cubit.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/show_add_subject_dialog.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/show_edit_semester_dialog.dart';
import 'package:gpa_calculator/core/widgets/custom_delete_dialog.dart';

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
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            onPressed: () =>
                showAddSubjectDialog(context, cubit, semesterEntity),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Course'),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            onPressed: () =>
                showEditSemesterDialog(context, cubit, semesterEntity),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () {
              showCustomDeleteDialog(
                context: context,
                title: 'Delete Semester',
                content: 'Are you sure you want to delete ${semesterEntity.semester.name} and all its subjects?',
                onDelete: () {
                  cubit.deleteSemester(semesterEntity.semester.id);
                },
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
