import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/semester_entity.dart';
import '../cubit/home_cubit.dart';

void showEditSemesterDialog(
  BuildContext context,
  HomeCubit cubit,
  SemesterEntity semesterEntity,
) {
  final nameController = TextEditingController(text: semesterEntity.semester.name);

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.bgDark,
        title: const Text('Edit Semester', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'Semester Name',
            labelStyle: TextStyle(color: AppColors.textMuted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textMuted)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.brandPurple)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                final updatedSemester = semesterEntity.semester.copyWith(name: newName);
                cubit.updateSemester(updatedSemester);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
