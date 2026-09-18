import '../../../../core/networking/api_result.dart';
import '../repositories/settings_repository.dart';
import '../../data/models/profile_model.dart';

class GetProfileUseCase {
  final SettingsRepository repository;

  GetProfileUseCase(this.repository);

  Future<ApiResult<ProfileModel>> call(String userId) {
    return repository.getProfile(userId);
  }
}
