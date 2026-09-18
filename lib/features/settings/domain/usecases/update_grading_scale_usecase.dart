import '../../../../core/networking/api_result.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/settings_repository.dart';
import '../../data/models/grading_scale_model.dart';

class UpdateGradingScaleUseCase {
  final SettingsRepository repository;

  UpdateGradingScaleUseCase(this.repository);

  Future<ApiResult<void>> call(
    String userId,
    List<GradingScaleModel> gradingScale,
  ) async {
    final enabledGrades = gradingScale.where((g) => g.enable).toList();
    for (int i = 0; i < enabledGrades.length - 1; i++) {
      final current = enabledGrades[i];
      final next = enabledGrades[i + 1];

      if (current.gpa < next.gpa) {
        return FailureResult(
          ValidationFailure(
            'Validation Failed: ${current.letter} GPA (${current.gpa}) cannot be less than ${next.letter} GPA (${next.gpa}).',
          ),
        );
      }

      if (current.minScore <= next.minScore) {
        return FailureResult(
          ValidationFailure(
            'Validation Failed: ${current.letter} minimum score (${current.minScore}) must be strictly greater than ${next.letter} minimum score (${next.minScore}).',
          ),
        );
      }
    }

    return repository.updateGradingScale(userId, gradingScale);
  }
}
