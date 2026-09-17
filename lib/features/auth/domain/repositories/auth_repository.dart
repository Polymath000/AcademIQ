import '../../../../core/networking/api_result.dart';
import '../../data/models/login_params.dart';
import '../../data/models/register_params.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<UserEntity>> login(LoginParams params);
  Future<ApiResult<UserEntity>> register(RegisterParams params);
  Future<void> logout();
  Future<ApiResult<UserEntity?>> getCurrentUser();
}
