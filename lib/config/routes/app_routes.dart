import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utls/setup_service_locator.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';

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
            create: (_) => sl<SplashCubit>(),
            child: const SplashView(),
          ),
        );
      case onboarding:
        return _fadeRoute(
          BlocProvider<OnboardingCubit>(
            create: (_) => sl<OnboardingCubit>(),
            child: const OnboardingView(),
          ),
        );
      case login:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Login Screen (Sprint 3)'))));
      case home:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Home Dashboard (Sprint 4)'))));
      default:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Page Not Found'))));
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
