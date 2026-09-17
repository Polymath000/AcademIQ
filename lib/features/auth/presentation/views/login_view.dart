import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/core/widgets/app_snack_bar.dart';
import 'package:gpa_calculator/features/auth/presentation/widgets/login_form.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/orbital_loading_indicator.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppSnackBar.show(
              context,
              message: "Welcome back.",
              type: SnackBarType.success,
            );
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthError) {
            AppSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: const LoginForm(),
                  ),
                ),
              ),
              if (state is AuthLoading)
                Container(
                  color: AppColors.bgDark.withValues(alpha: 0.75),
                  child: const Center(
                    child: OrbitalLoadingIndicator(size: 120),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
