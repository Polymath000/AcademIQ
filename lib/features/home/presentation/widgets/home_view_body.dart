import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/home/presentation/cubit/home_cubit.dart';
import 'package:gpa_calculator/features/home/presentation/widgets/cgpa_dashboard_card.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CgpaDashboardCard(
                    cgpa: cgpa,
                    maxGpa: maxGpa,
                    totalCredits: totalCredits,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Semesters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPurpleLight,
                          side: const BorderSide(color: AppColors.buttonBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onPressed: () => _showAddSemesterDialog(
                          context,
                          context.read<HomeCubit>(),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Semester', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          if (semesters.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Center(
                  child: Text(
                    'No semesters yet. Tap "Add Semester" to add one!',
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
                horizontal: 24.0,
                vertical: 0.0,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final semesterEntity = semesters[index];
                  return SemesterCard(semesterEntity: semesterEntity);
                }, childCount: semesters.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
