import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/semester_card_actions.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/semester_header.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/semester_entity.dart';
import '../cubit/home_cubit.dart';
import 'subject_list_item.dart';

class SemesterCard extends StatelessWidget {
  final SemesterEntity semesterEntity;

  const SemesterCard({super.key, required this.semesterEntity});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: AppColors.semesterCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: SemesterHeader(semester: semesterEntity),
          iconColor: AppColors.textMuted,
          collapsedIconColor: AppColors.textMuted,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
            if (semesterEntity.subjects.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No courses added yet.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: semesterEntity.subjects.length,
                itemBuilder: (context, index) {
                  return SubjectListItem(
                    subject: semesterEntity.subjects[index],
                    cubit: cubit,
                  );
                },
              ),
            SemesterCardActions(semesterEntity: semesterEntity, cubit: cubit),
          ],
        ),
      ),
    );
  }
}
