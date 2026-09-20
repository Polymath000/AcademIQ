import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/features/settings/presentation/widget/personal_info_section.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gpa_calculator/core/widgets/app_snack_bar.dart';
import 'package:gpa_calculator/core/widgets/app_error_widget.dart';
import 'package:gpa_calculator/core/widgets/orbital_loading_indicator.dart';
import 'package:gpa_calculator/features/settings/presentation/widget/grade_item_row.dart';

import '../../data/models/profile_model.dart';
import '../../data/models/grading_scale_model.dart';
import '../utils/settings_mocks.dart';

import '../../../../core/utls/setup_service_locator.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/borders.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsBody();
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              AppSnackBar.show(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            } else if (state is SettingsLoggedOut) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
            }
          },
          builder: (context, state) {
            bool isLoading =
                state is SettingsLoading || state is SettingsInitial;
            bool isSaving = false;

            ProfileModel profile;
            List<GradingScaleModel> draftScale;

            if (state is SettingsLoaded) {
              profile = state.profile;
              draftScale = state.draftScale;
              isSaving = state.isSaving;
            } else if (state is SettingsError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => context.read<SettingsCubit>().loadSettings(),
              );
            } else {
              profile = SettingsMocks.dummyProfile;
              draftScale = SettingsMocks.dummyGradingScale;
            }

            return Stack(
              children: [
                Skeletonizer(
                  enabled: isLoading,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Settings', style: AppTextStyles.h1),
                        const SizedBox(height: 32),
                        PersonalInfoSection(profile: profile),

                        const SizedBox(height: 40),
                        Text('Grading Scale', style: AppTextStyles.h3),
                        const SizedBox(height: 8),
                        Text(
                          'Edit minimum scores, GPA values, and toggle which grades are used by your university.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: AppBorders.m,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: draftScale.length,
                            separatorBuilder: (context, index) => const Divider(
                              color: AppColors.border,
                              height: 1,
                            ),
                            itemBuilder: (context, index) {
                              final grade = draftScale[index];
                              return GradeItemRow(
                                grade: grade,
                                index: index,
                                key: ValueKey(grade.letter),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        AppButton(
                          text: isSaving ? 'Saving...' : 'Save Grading Scale',
                          onPressed: isSaving || isLoading
                              ? null
                              : () {
                                  context
                                      .read<SettingsCubit>()
                                      .saveGradingScale();
                                },
                          backgroundColor: AppColors.brandPurple,
                          foregroundColor: AppColors.bgDark,
                        ),

                        const SizedBox(height: 32),

                        AppButton(
                          text: 'Log Out',
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<SettingsCubit>().logout();
                                },
                          backgroundColor: AppColors.errorBg,
                          foregroundColor: AppColors.error,
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
                if (isSaving)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.bgDark.withValues(alpha: 0.7),
                      child: const Center(
                        child: OrbitalLoadingIndicator(size: 100),
                      ),
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
