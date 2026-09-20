import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/features/ai_advisor/presentation/widgets/ai_advisor_view_body.dart';

import '../../../../config/theme/app_colors.dart';
import '../cubit/ai_advisor_cubit.dart';

import '../../../../core/utls/setup_service_locator.dart';

class AiAdvisorView extends StatelessWidget {
  const AiAdvisorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getit<AiAdvisorCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.transparent,

        body: const AiAdvisorViewBody(),
      ),
    );
  }
}
