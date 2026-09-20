import 'package:gpa_calculator/core/networking/api_result.dart';
import 'package:gpa_calculator/features/ai_advisor/domain/repositories/ai_advisor_repository.dart';
import 'package:gpa_calculator/features/home/domain/entities/semester_entity.dart';
import 'package:gpa_calculator/features/settings/data/models/profile_model.dart';

class GetAiAnalysisUseCase {
  final AiAdvisorRepository _repository;

  GetAiAnalysisUseCase(this._repository);

  Future<ApiResult<String>> call(ProfileModel profile, List<SemesterEntity> semesters) async {
    final prompt = _buildPrompt(profile, semesters);
    return await _repository.getAiAnalysis(prompt, profile.id);
  }

  String _buildPrompt(ProfileModel profile, List<SemesterEntity> semesters) {
    String prompt = "Student's Current Profile:\n"
        "- Current CGPA: ${profile.cgpa.toStringAsFixed(2)} out of 4.0 (assuming standard)\n"
        "- Total Credits Earned: ${profile.totalCredits}\n"
        "\nStudent's Transcript:\n";

    if (semesters.isEmpty) {
      prompt += "The student has not recorded any semesters or courses yet.\n";
    } else {
      for (var semester in semesters) {
        prompt += "Semester: ${semester.semester.name}\n";
        if (semester.subjects.isEmpty) {
          prompt += "  (No subjects recorded)\n";
        }
        for (var subject in semester.subjects) {
          prompt += "  - ${subject.name}: ${subject.gradeLetter} (${subject.credits} credits)\n";
        }
      }
    }

    prompt += "\nBased on this transcript, please provide:\n"
        "1. An analysis of their academic strengths and weaknesses.\n"
        "2. Specific strategies on how they can improve their GPA.\n"
        "3. Recommendations for types of courses, YouTube playlists, books, or articles they should study to improve their weak areas.\n";

    return prompt;
  }
}
