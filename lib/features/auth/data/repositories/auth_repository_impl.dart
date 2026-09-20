import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../models/login_params.dart';
import '../models/register_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<UserEntity>> login(LoginParams params) async {
    try {
      final response = await _remoteDataSource.login(params);
      final user = response.user;
      if (user != null) {
        return Success(
          UserEntity(
            id: user.id,
            email: user.email ?? '',
            displayName: user.userMetadata?['full_name'] as String? ?? 'User',
          ),
        );
      } else {
        return FailureResult(
          ApiErrorHandler.handle('There\'s an error, Please try again.')
              .toFailure(),
        );
      }
    } catch (e) {
      return FailureResult(ApiErrorHandler.handle(e).toFailure());
    }
  }

  @override
  Future<ApiResult<UserEntity>> register(RegisterParams params) async {
    try {
      final response = await _remoteDataSource.register(params);
      final user = response.user;
      if (user != null) {
        return Success(
          UserEntity(
            id: user.id,
            email: user.email ?? '',
            displayName: params.name,
          ),
        );
      } else {
        return FailureResult(
          ApiErrorHandler.handle('There was an error during registration.')
              .toFailure(),
        );
      }
    } catch (e) {
      return FailureResult(ApiErrorHandler.handle(e).toFailure());
    }
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<ApiResult<UserEntity?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.getCurrentUser();
      if (user != null) {
        return Success(
          UserEntity(
            id: user.id,
            email: user.email ?? '',
            displayName: user.userMetadata?['full_name'] as String? ?? 'User',
          ),
        );
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(ApiErrorHandler.handle(e).toFailure());
    }
  }
}
