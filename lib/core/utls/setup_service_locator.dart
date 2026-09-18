import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../networking/network_info.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/main_layout/presentation/cubit/main_layout_cubit.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/datasources/settings_remote_data_source.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/data/models/profile_model.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/domain/usecases/get_profile_usecase.dart';
import '../../features/settings/domain/usecases/update_grading_scale_usecase.dart';

final getit = GetIt.instance;

Future<void> setupServiceLocator() async {
  getit.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  getit.registerLazySingleton(() => Connectivity());
  getit.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getit()));

  // Auth
  getit.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getit(), getit()),
  );
  getit.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getit()),
  );

  // Settings
  getit.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(Hive.box<ProfileModel>('settings_box')),
  );
  getit.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(getit()),
  );
  getit.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getit(), getit(), getit()),
  );

  // UseCases
  getit.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getit()),
  );
  getit.registerLazySingleton<UpdateGradingScaleUseCase>(
    () => UpdateGradingScaleUseCase(getit()),
  );

  // Cubits
  getit.registerFactory<SplashCubit>(() => SplashCubit(getit()));
  getit.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  getit.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getit()));
  getit.registerFactory<MainLayoutCubit>(() => MainLayoutCubit());
  getit.registerFactory<SettingsCubit>(() => SettingsCubit(getit(), getit(), getit()));
}
