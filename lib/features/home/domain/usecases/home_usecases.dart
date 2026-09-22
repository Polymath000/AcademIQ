import '../../domain/entities/semester_entity.dart';
import '../../../../core/networking/api_result.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';
import '../repositories/home_repository.dart';
import '../utils/gpa_calculator_util.dart';
import '../../../settings/data/models/grading_scale_model.dart';

class GetHomeDataUseCase {
  final HomeRepository _repository;

  GetHomeDataUseCase(this._repository);

  Future<ApiResult<List<SemesterEntity>>> call(String userId) async {
    await _repository.syncData(userId);

    final semestersResult = await _repository.getSemesters();
    final subjectsResult = await _repository.getSubjects();

    if (semestersResult is Success<List<SemesterModel>> &&
        subjectsResult is Success<List<SubjectModel>>) {
      final semesters = semestersResult.data;
      final subjects = subjectsResult.data;

      final entities = semesters.map((semester) {
        final semSubjects = subjects
            .where((s) => s.semesterId == semester.id)
            .toList();
        return SemesterEntity(semester: semester, subjects: semSubjects);
      }).toList();

      return Success(entities);
    }

    if (semestersResult is FailureResult<List<SemesterModel>>) {
      return FailureResult(semestersResult.failure);
    }

    return FailureResult((subjectsResult as FailureResult).failure);
  }
}

class ManageSemesterUseCase {
  final HomeRepository _repository;

  ManageSemesterUseCase(this._repository);

  Future<ApiResult<void>> add(SemesterModel semester) =>
      _repository.addSemester(semester);
  Future<ApiResult<void>> update(SemesterModel semester) =>
      _repository.updateSemester(semester);
  Future<ApiResult<void>> delete(String semesterId) =>
      _repository.deleteSemester(semesterId);
}

class ManageSubjectUseCase {
  final HomeRepository _repository;

  ManageSubjectUseCase(this._repository);

  Future<ApiResult<void>> add(SubjectModel subject) =>
      _repository.addSubject(subject);
  Future<ApiResult<void>> update(SubjectModel subject) =>
      _repository.updateSubject(subject);
  Future<ApiResult<void>> delete(String subjectId) =>
      _repository.deleteSubject(subjectId);
}

class CalculateAndSyncCGPAUseCase {
  final HomeRepository _homeRepository;

  CalculateAndSyncCGPAUseCase(this._homeRepository);

  Future<ApiResult<Map<String, dynamic>>> call({
    required String userId,
    required List<SubjectModel> allSubjects,
    required List<GradingScaleModel> gradingScale,
  }) async {
    final result = GpaCalculatorUtil.calculateCGPA(
      subjects: allSubjects,
      gradingScale: gradingScale,
    );

    final double cgpa = result['cgpa'];
    final int totalCredits = result['totalCredits'];

    final syncResult = await _homeRepository.syncProfileCGPA(
      userId,
      cgpa,
      totalCredits,
    );

    if (syncResult is Success) {
      return Success({'cgpa': cgpa, 'totalCredits': totalCredits});
    }

    return FailureResult((syncResult as FailureResult).failure);
  }
}
