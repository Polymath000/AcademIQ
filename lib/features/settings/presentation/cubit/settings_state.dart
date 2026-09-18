import 'package:equatable/equatable.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/grading_scale_model.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final ProfileModel profile;
  final List<GradingScaleModel> draftScale;
  final bool isSaving;

  const SettingsLoaded({
    required this.profile,
    required this.draftScale,
    this.isSaving = false,
  });

  SettingsLoaded copyWith({
    ProfileModel? profile,
    List<GradingScaleModel>? draftScale,
    bool? isSaving,
  }) {
    return SettingsLoaded(
      profile: profile ?? this.profile,
      draftScale: draftScale ?? this.draftScale,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [profile, draftScale, isSaving];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingsLoggedOut extends SettingsState {}
