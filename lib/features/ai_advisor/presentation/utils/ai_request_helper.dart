import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../settings/data/models/profile_model.dart';
import '../../../home/domain/entities/semester_entity.dart';
import '../cubit/ai_advisor_cubit.dart';

void requestAiAnalysis(BuildContext context, ProfileModel profile, List<SemesterEntity> semesters) {
  if (profile.isQuotaFinished) {
    AppSnackBar.show(context, message: 'You have reached your AI limit.', type: SnackBarType.error);
    return;
  }
  context.read<AiAdvisorCubit>().generateAnalysis(profile, semesters);
}
