import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_cubit.dart';

Future<dynamic> showAddNewSemesterDialog(
  BuildContext context,
  TextEditingController nameController,
  HomeCubit cubit,
) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.navBarBg,
        title: const Text('Add New Semester'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Semester Name',
            hintText: 'e.g. Fall 2023',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPurple,
              foregroundColor: AppColors.textPrimary,
            ),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                cubit.addSemester(name);
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
