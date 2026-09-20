import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_cubit.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/cgpa_circular_display.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/semester_card.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/show_add_new_semester_dialog.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
    required this.cgpa,
    required this.maxGpa,
    required this.totalCredits,
    required this.semesters,
  });

  final double cgpa;
  final double maxGpa;
  final int totalCredits;
  final List<SemesterEntity> semesters;

  void _showAddSemesterDialog(BuildContext context, HomeCubit cubit) {
    final TextEditingController nameController = TextEditingController();

    showAddNewSemesterDialog(context, nameController, cubit);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().loadData(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CgpaCircularDisplay(
                    cgpa: cgpa,
                    maxGpa: maxGpa,
                    totalCredits: totalCredits,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPurple,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _showAddSemesterDialog(
                        context,
                        context.read<HomeCubit>(),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Semester'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (semesters.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Center(
                  child: Text(
                    'No semesters yet. Tap "Add New Semester" to add one!',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final semesterEntity = semesters[index];
                  return SemesterCard(semesterEntity: semesterEntity);
                }, childCount: semesters.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
