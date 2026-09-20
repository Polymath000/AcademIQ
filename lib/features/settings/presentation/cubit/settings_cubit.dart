import '../../../../config/routes/app_routes.dart';
import '../../../../gpa_calculator_app.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_grading_scale_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'settings_state.dart';
import '../../data/models/grading_scale_model.dart';
import '../../data/models/profile_model.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateGradingScaleUseCase _updateGradingScaleUseCase;
  final AuthRepository _authRepository;

  SettingsCubit(
    this._getProfileUseCase,
    this._updateGradingScaleUseCase,
    this._authRepository,
  ) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());

    final userResult = await _authRepository.getCurrentUser();

    await userResult.when(
      success: (user) async {
        if (user != null) {
          final profileResult = await _getProfileUseCase(user.id);

          profileResult.when(
            success: (profile) => emit(
              SettingsLoaded(
                profile: profile,
                draftScale: List.from(profile.gradingScale),
              ),
            ),
            failure: (error) => emit(SettingsError(error.message)),
          );
        } else {
          emit(const SettingsError('User not logged in'));
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      failure: (error) {
        emit(SettingsError(error.message));
      },
    );
  }

  void updateDraftGrade(int index, {double? gpa, int? minScore, bool? enable}) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedScale = List<GradingScaleModel>.from(
        currentState.draftScale,
      );

      final oldGrade = updatedScale[index];
      updatedScale[index] = GradingScaleModel(
        letter: oldGrade.letter,
        gpa: gpa ?? oldGrade.gpa,
        minScore: minScore ?? oldGrade.minScore,
        enable: enable ?? oldGrade.enable,
      );

      emit(currentState.copyWith(draftScale: updatedScale));
    }
  }

  Future<void> saveGradingScale() async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(currentState.copyWith(isSaving: true));

      final result = await _updateGradingScaleUseCase(
        currentState.profile.id,
        currentState.draftScale,
      );

      result.when(
        success: (_) {
          final updatedProfile = ProfileModel(
            id: currentState.profile.id,
            fullName: currentState.profile.fullName,
            email: currentState.profile.email,
            gradingScale: currentState.draftScale,
          );
          emit(
            SettingsLoaded(
              profile: updatedProfile,
              draftScale: currentState.draftScale,
            ),
          );
        },
        failure: (error) {
          emit(SettingsError('Failed to save: ${error.message}'));
          emit(currentState.copyWith(isSaving: false));
        },
      );
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(SettingsLoggedOut());
  }
}
