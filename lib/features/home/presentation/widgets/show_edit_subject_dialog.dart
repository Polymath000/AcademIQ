import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';

import '../../data/models/subject_model.dart';
import '../cubit/home_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';

void showEditSubjectDialog(
  BuildContext context,
  HomeCubit cubit,
  SubjectModel existingSubject,
) {
  final TextEditingController nameController = TextEditingController(text: existingSubject.name);
  final TextEditingController creditsController = TextEditingController(text: existingSubject.credits.toString());

  final settingsState = context.read<SettingsCubit>().state;
  final enabledGrades = settingsState is SettingsLoaded 
      ? settingsState.profile.gradingScale.where((g) => g.enable).toList()
      : [];

  String? selectedGrade = existingSubject.gradeLetter;
  
  // Just in case the previously selected grade is no longer enabled, fallback or add it
  if (!enabledGrades.any((g) => g.letter == selectedGrade)) {
    if (enabledGrades.isNotEmpty) {
      selectedGrade = enabledGrades.first.letter;
    } else {
      selectedGrade = null;
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.navBarBg,
            title: const Text('Edit Subject'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Subject Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: creditsController,
                  decoration: const InputDecoration(labelText: 'Credits (e.g. 3)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedGrade,
                  decoration: const InputDecoration(
                    labelText: 'Grade',
                  ),
                  dropdownColor: AppColors.navBarBg,
                  items: enabledGrades.map<DropdownMenuItem<String>>((grade) {
                    return DropdownMenuItem(
                      value: grade.letter,
                      child: Text(grade.letter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGrade = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final credits = int.tryParse(creditsController.text.trim()) ?? 0;
                  final grade = selectedGrade;

                  if (name.isNotEmpty && credits > 0 && grade != null && grade.isNotEmpty) {
                    final updatedSubject = existingSubject.copyWith(
                      name: name,
                      credits: credits,
                      gradeLetter: grade,
                    );
                    cubit.updateSubject(updatedSubject);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
