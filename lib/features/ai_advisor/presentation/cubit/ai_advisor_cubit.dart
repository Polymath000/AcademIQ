import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_ai_analysis_usecase.dart';
import 'ai_advisor_state.dart';
import '../../../home/domain/entities/semester_entity.dart';
import '../../../settings/data/models/profile_model.dart';

class AiAdvisorCubit extends Cubit<AiAdvisorState> {
  final GetAiAnalysisUseCase _getAiAnalysisUseCase;

  AiAdvisorCubit(this._getAiAnalysisUseCase) : super(AiAdvisorInitial());

  Future<void> generateAnalysis(
    ProfileModel profile,
    List<SemesterEntity> semesters,
  ) async {
    if (profile.isQuotaFinished) {
      emit(AiAdvisorError('You have reached your AI limit.'));
      return;
    }

    bool hasAnyCourse = semesters.any((sem) => sem.subjects.isNotEmpty);
    if (!hasAnyCourse) {
      emit(AiAdvisorError('You have no subjects to analyze. Please add some courses first.'));
      return;
    }

    emit(AiAdvisorLoading());

    final result = await _getAiAnalysisUseCase.call(profile, semesters);

    result.when(
      success: (analysis) {
        emit(AiAdvisorLoaded(analysis));
      },
      failure: (failure) {
        emit(AiAdvisorError(failure.message));
      },
    );
  }

  void reset() {
    emit(AiAdvisorInitial());
  }
}
