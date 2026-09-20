import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/orbital_loading_indicator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
return Container(
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        gradient: LinearGradient(
          colors: [
            AppColors.gradeWeak.withValues(alpha: 0.2),
            AppColors.brandIndigo.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppSnackBar.show(
              context,
              message: "Welcome to AcademIQ.",
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
                    child: const RegisterForm(),
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
      ),
    );
  }
}
