import '../../../../core/errors/failures.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/network_info.dart';
import '../../domain/repositories/ai_advisor_repository.dart';
import '../datasources/ai_advisor_remote_data_source.dart';

class AiAdvisorRepositoryImpl implements AiAdvisorRepository {
  final AiAdvisorRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AiAdvisorRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<ApiResult<String>> getAiAnalysis(String prompt, String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final analysis = await _remoteDataSource.getAiAnalysis(prompt);
        await _remoteDataSource.incrementAiUsage(userId);

        return Success(analysis);
      } catch (e) {
        return FailureResult(
          ServerFailure('Failed to generate analysis. Please try again.'),
        );
      }
    } else {
      return FailureResult(ServerFailure('No internet connection.'));
    }
  }
}
