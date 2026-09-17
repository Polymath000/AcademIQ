import 'package:flutter/material.dart';

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
        return _fadeRoute(const Scaffold(body: Center(child: Text('Splash'))));
      case onboarding:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Onboarding'))));
      case login:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Login'))));
      case home:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Home'))));
      default:
        return _fadeRoute(const Scaffold(body: Center(child: Text('Not Found'))));
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
