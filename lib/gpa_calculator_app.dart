import 'package:flutter/material.dart';
import 'package:gpa_calculator/config/routes/app_routes.dart';
import 'package:gpa_calculator/config/theme/app_theme.dart';
import 'package:gpa_calculator/core/constants/constants.dart';

class GpaCalculatorApp extends StatelessWidget {
  const GpaCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
