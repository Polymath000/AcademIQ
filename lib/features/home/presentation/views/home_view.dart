import '../../../../config/routes/app_routes.dart';

import 'package:gpa_calculator/features/home/presentation/widgets/home_view_body.dart';

import '../widgets/home_app_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../config/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utls/setup_service_locator.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
            return const Center(child: CircularProgressIndicator());
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
