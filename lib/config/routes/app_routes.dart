import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utls/setup_service_locator.dart';
import '../../core/widgets/app_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/main_layout/presentation/cubit/main_layout_cubit.dart';
import '../../features/main_layout/presentation/views/main_layout_view.dart';

sealed class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String aiAdvisor = '/aiAdvisor';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(
          BlocProvider<SplashCubit>(
            create: (_) => getit<SplashCubit>(),
            child: const SplashView(),
          ),
        );
      case onboarding:
        return _fadeRoute(
          BlocProvider<OnboardingCubit>(
            create: (_) => getit<OnboardingCubit>(),
            child: const OnboardingView(),
          ),
        );
      case login:
        return _fadeRoute(
          BlocProvider<AuthCubit>(
            create: (_) => getit<AuthCubit>(),
            child: const LoginView(),
          ),
        );
      case register:
        return _fadeRoute(
          BlocProvider<AuthCubit>(
            create: (_) => getit<AuthCubit>(),
            child: const RegisterView(),
          ),
        );
      case home:
        return _fadeRoute(
          BlocProvider<MainLayoutCubit>(
            create: (_) => getit<MainLayoutCubit>(),
            child: const MainLayoutView(),
          ),
        );
      default:
        return _fadeRoute(PageNotFoundView());
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

class PageNotFoundView extends StatelessWidget {
  const PageNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.brandPurple.withValues(alpha: 0.35),
                        AppColors.brandIndigo.withValues(alpha: 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppColors.brandPurple.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandPurple.withValues(alpha: 0.3),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    AppIcons.notFound,
                    size: 44,
                    color: AppColors.brandAccent,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.brandAccent.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '404 NOT FOUND',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.brandAccent,
                      letterSpacing: 1.2,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Lost in Cyberspace',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  'The page you requested could not be found.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Back to Home',
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.home);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
