import '../../../../core/networking/api_result.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';

abstract class HomeRepository {
  Future<ApiResult<void>> syncData(String userId);

  Future<ApiResult<List<SemesterModel>>> getSemesters();
  Future<ApiResult<void>> addSemester(SemesterModel semester);
  Future<ApiResult<void>> deleteSemester(String semesterId);

  Future<ApiResult<List<SubjectModel>>> getSubjects();
  Future<ApiResult<void>> addSubject(SubjectModel subject);
  Future<ApiResult<void>> updateSubject(SubjectModel subject);
  Future<ApiResult<void>> deleteSubject(String subjectId);

  Future<ApiResult<void>> syncProfileCGPA(String userId, double cgpa, int totalCredits);
  
  Future<void> processSyncQueue();
}
