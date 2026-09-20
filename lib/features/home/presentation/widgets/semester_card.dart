import '../../../../config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/semester_entity.dart';
import '../../data/models/subject_model.dart';
import '../cubit/home_cubit.dart';

class SemesterCard extends StatelessWidget {
  final SemesterEntity semesterEntity;

  const SemesterCard({
    super.key,
    required this.semesterEntity,
  });

  void _showAddSubjectDialog(BuildContext context, HomeCubit cubit) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController creditsController = TextEditingController();
    final TextEditingController gradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
              ),
              TextField(
                controller: creditsController,
                decoration: const InputDecoration(labelText: 'Credits (e.g. 3)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Grade (e.g. A+)'),
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
                final grade = gradeController.text.trim().toUpperCase();

                if (name.isNotEmpty && credits > 0 && grade.isNotEmpty) {
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
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(
          semesterEntity.semester.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: AppColors.error),
          onPressed: () {
            // Confirm deletion
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Semester'),
                content: const Text('Are you sure you want to delete this semester and all its subjects?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
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
        ),
        children: [
          if (semesterEntity.subjects.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No subjects added yet.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: semesterEntity.subjects.length,
              itemBuilder: (context, index) {
                final subject = semesterEntity.subjects[index];
                return ListTile(
                  title: Text(subject.name),
                  subtitle: Text('${subject.credits} Credits'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          subject.gradeLetter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => cubit.deleteSubject(subject.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () => _showAddSubjectDialog(context, cubit),
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            ),
          ),
        ],
      ),
    );
  }
}
