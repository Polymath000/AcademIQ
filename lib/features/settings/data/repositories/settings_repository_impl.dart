import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/profile_model.dart';
import '../models/grading_scale_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;
  final SettingsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  SettingsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<ApiResult<ProfileModel>> getProfile(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final profile = await _remoteDataSource.getProfile(userId);
        await _localDataSource.cacheProfile(profile);
        return Success(profile);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      try {
        final cachedProfile = await _localDataSource.getCachedProfile();
        if (cachedProfile != null) {
          return Success(cachedProfile);
        } else {
          return FailureResult(
            ApiErrorHandler.handle(NoInternetException()).toFailure(),
          );
        }
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    }
  }

  @override
  Future<ApiResult<void>> updateGradingScale(
    String userId,
    List<GradingScaleModel> gradingScale,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.updateGradingScale(userId, gradingScale);
        final cachedProfile = await _localDataSource.getCachedProfile();
        if (cachedProfile != null) {
          final updatedProfile = ProfileModel(
            id: cachedProfile.id,
            fullName: cachedProfile.fullName,
            email: cachedProfile.email,
            gradingScale: gradingScale,
          );
          await _localDataSource.cacheProfile(updatedProfile);
        }
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return FailureResult(
        ApiErrorHandler.handle(NoInternetException()).toFailure(),
      );
    }
  }
}
