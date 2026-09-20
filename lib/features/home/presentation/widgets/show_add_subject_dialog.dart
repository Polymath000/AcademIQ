import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/semester_entity.dart';
import '../../data/models/subject_model.dart';
import '../cubit/home_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';

void showAddSubjectDialog(
  BuildContext context,
  HomeCubit cubit,
  SemesterEntity semesterEntity,
) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController creditsController = TextEditingController();

  final settingsState = context.read<SettingsCubit>().state;
  final enabledGrades = settingsState is SettingsLoaded 
      ? settingsState.profile.gradingScale.where((g) => g.enable).toList()
      : [];

  String? selectedGrade;
  if (enabledGrades.isNotEmpty) {
    selectedGrade = enabledGrades.first.letter;
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.navBarBg,
            title: const Text('Add Subject'),
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
                    final newSubject = SubjectModel(
                      id: const Uuid().v4(),
                      semesterId: semesterEntity.semester.id,
                      userId: semesterEntity.semester.userId,
                      name: name,
                      credits: credits,
                      gradeLetter: grade,
                      createdAt: DateTime.now(),
                    );
                    cubit.addSubject(newSubject);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
