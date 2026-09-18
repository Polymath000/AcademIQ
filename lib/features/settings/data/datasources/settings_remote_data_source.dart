import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import '../models/grading_scale_model.dart';

abstract class SettingsRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> updateGradingScale(
    String userId,
    List<GradingScaleModel> gradingScale,
  );
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SettingsRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final response = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  @override
  Future<void> updateGradingScale(
    String userId,
    List<GradingScaleModel> gradingScale,
  ) async {
    final scaleJson = gradingScale.map((e) => e.toJson()).toList();

    await _supabaseClient
        .from('profiles')
        .update({'grading_scale': scaleJson})
        .eq('id', userId);
  }
}
