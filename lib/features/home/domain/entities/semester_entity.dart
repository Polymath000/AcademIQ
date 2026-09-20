import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';

class SemesterEntity {
  final SemesterModel semester;
  final List<SubjectModel> subjects;

  const SemesterEntity({
    required this.semester,
    required this.subjects,
  });

  int get totalCredits => subjects.fold(0, (sum, subject) => sum + subject.credits);
}
