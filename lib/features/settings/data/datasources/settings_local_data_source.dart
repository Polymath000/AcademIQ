import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:hive/hive.dart';

import '../models/profile_model.dart';

abstract class SettingsLocalDataSource {
  Future<void> cacheProfile(ProfileModel profileToCache);
  Future<ProfileModel?> getCachedProfile();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box<ProfileModel> _settingsBox;

  SettingsLocalDataSourceImpl(this._settingsBox);

  @override
  Future<void> cacheProfile(ProfileModel profileToCache) async {
    await _settingsBox.put(AppConstants.cacheProfileKey, profileToCache);
  }

  @override
  Future<ProfileModel?> getCachedProfile() async {
    return _settingsBox.get(AppConstants.cacheProfileKey);
  }
}
