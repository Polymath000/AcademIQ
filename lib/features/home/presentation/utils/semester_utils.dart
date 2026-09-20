import '../../domain/entities/semester_entity.dart';
import '../../../settings/data/models/grading_scale_model.dart';

class SemesterUtils {
  static double calculateSemesterGpa(SemesterEntity semester, List<GradingScaleModel> scale) {
    double totalPoints = 0.0;
    int credsForGpa = 0;

    for (var subject in semester.subjects) {
      final match = scale
          .where((s) => s.letter == subject.gradeLetter)
          .firstOrNull;
      if (match != null) {
        totalPoints += match.gpa * subject.credits;
        credsForGpa += subject.credits;
      }
    }
    return credsForGpa > 0 ? (totalPoints / credsForGpa) : 0.0;
  }
}
