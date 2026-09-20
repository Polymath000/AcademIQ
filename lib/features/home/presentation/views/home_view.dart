import 'package:skeletonizer/skeletonizer.dart';
import '../../domain/entities/semester_entity.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';
import '../../../../config/routes/app_routes.dart';

import 'package:gpa_calculator/features/home/presentation/widgets/home_view_body.dart';

import '../widgets/home_app_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../config/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  List<SemesterEntity> _getDummySemesters() {
    return [
      SemesterEntity(
        semester: SemesterModel(id: '1', userId: 'mock', name: 'Semester 1', orderIndex: 0, createdAt: DateTime.now()),
        subjects: [
          SubjectModel(id: '1', semesterId: '1', userId: 'mock', name: 'Data Structures', credits: 4, gradeLetter: 'A+', createdAt: DateTime.now()),
          SubjectModel(id: '2', semesterId: '1', userId: 'mock', name: 'Discrete Math', credits: 3, gradeLetter: 'B+', createdAt: DateTime.now()),
        ],
      ),
      SemesterEntity(
        semester: SemesterModel(id: '2', userId: 'mock', name: 'Semester 2', orderIndex: 1, createdAt: DateTime.now()),
        subjects: [
          SubjectModel(id: '3', semesterId: '2', userId: 'mock', name: 'Algorithms', credits: 4, gradeLetter: 'A-', createdAt: DateTime.now()),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: const HomeAppBar(),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            if (state.message.toLowerCase().contains('not logged in')) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            } else {
              AppSnackBar.show(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          }
        },
        buildWhen: (previous, current) {
          return current is! HomeError;
        },
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return Skeletonizer(
              enabled: true,
              effect: const ShimmerEffect(
                baseColor: AppColors.semesterCardBg,
                highlightColor: AppColors.cardGradientStart,
              ),
              child: HomeViewBody(
                cgpa: 3.52,
                maxGpa: 4.0,
                totalCredits: 36,
                semesters: _getDummySemesters(),
              ),
            );
          }

          if (state is HomeLoaded) {
            return HomeViewBody(
              cgpa: state.cgpa,
              maxGpa: state.maxGpa,
              totalCredits: state.totalCredits,
              semesters: state.semesters,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
