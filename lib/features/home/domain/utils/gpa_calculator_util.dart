import '../../data/models/subject_model.dart';
import '../../../settings/data/models/grading_scale_model.dart';

class GpaCalculatorUtil {
  /// Calculates the cumulative GPA and total credits based on subjects and grading scale.
  /// Ignores subjects with a grade letter that doesn't exist in the active scale (or shouldn't be counted if we implement bypass logic later).
  static Map<String, dynamic> calculateCGPA({
    required List<SubjectModel> subjects,
    required List<GradingScaleModel> gradingScale,
  }) {
    double totalQualityPoints = 0.0;
    int totalCredits = 0;

    // Create a quick lookup map for the grading scale
    final scaleMap = {for (var grade in gradingScale) grade.letter: grade};

    for (var subject in subjects) {
      final matchingGrade = scaleMap[subject.gradeLetter];

      if (matchingGrade != null && matchingGrade.enable) {
        totalQualityPoints += matchingGrade.gpa * subject.credits;
        totalCredits += subject.credits;
      }
    }

    final double cgpa = totalCredits > 0
        ? (totalQualityPoints / totalCredits)
        : 0.0;

    return {
      'cgpa': double.parse(cgpa.toStringAsFixed(2)),
      'totalCredits': totalCredits,
    };
  }

  static Map<String, dynamic> calculateSemesterGPA({
    required String semesterId,
    required List<SubjectModel> allSubjects,
    required List<GradingScaleModel> gradingScale,
  }) {
    final semesterSubjects = allSubjects
        .where((s) => s.semesterId == semesterId)
        .toList();
    return calculateCGPA(
      subjects: semesterSubjects,
      gradingScale: gradingScale,
    );
  }
}
