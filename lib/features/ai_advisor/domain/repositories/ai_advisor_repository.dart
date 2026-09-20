import '../../../../core/networking/api_result.dart';

abstract class AiAdvisorRepository {
  Future<ApiResult<String>> getAiAnalysis(String prompt, String userId);
}
