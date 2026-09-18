import '../../../../core/networking/api_result.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/grading_scale_model.dart';

abstract class SettingsRepository {
  Future<ApiResult<ProfileModel>> getProfile(String userId);
  Future<ApiResult<void>> updateGradingScale(String userId, List<GradingScaleModel> gradingScale);
}
