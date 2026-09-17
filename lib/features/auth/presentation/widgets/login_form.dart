import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';
import 'package:gpa_calculator/core/constants/app_icons.dart';
import 'package:gpa_calculator/core/widgets/app_button.dart';
import 'package:gpa_calculator/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:gpa_calculator/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:gpa_calculator/features/auth/presentation/widgets/register_link.dart';

class LoginForm extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            AppIcons.schoolRounded,
            size: 64,
            color: AppColors.brandPurple,
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome Back',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 8),
          Text(
            'Log in to track your GPA and get AI insights',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 48),

          AuthTextField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: AppIcons.emailOutline,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          AuthTextField(
            controller: _passwordController,
            hintText: 'Password',
            prefixIcon: AppIcons.lockOutline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: FaIcon(
                _obscurePassword
                    ? AppIcons.visibilityOff
                    : AppIcons.visibilityOn,
                color: Colors.white.withValues(alpha: 0.5),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          AppButton(
            text: 'Log In',
            onPressed: _onLogin,
          ),
          const SizedBox(height: 24),

          RegisterLink(),
        ],
      ),
    );
  }
}
