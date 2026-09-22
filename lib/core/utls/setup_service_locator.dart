import '../../features/ai_advisor/data/datasources/ai_advisor_remote_data_source.dart';
import '../../features/ai_advisor/domain/repositories/ai_advisor_repository.dart';
import '../../features/ai_advisor/data/repositories/ai_advisor_repository_impl.dart';
import '../../features/ai_advisor/domain/usecases/get_ai_analysis_usecase.dart';
import '../../features/ai_advisor/presentation/cubit/ai_advisor_cubit.dart';

import 'package:get_it/get_it.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
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
import '../../features/home/data/models/semester_model.dart';
import '../../features/home/data/models/subject_model.dart';
import '../../features/home/data/models/sync_action_model.dart';
import '../../features/home/data/datasources/home_local_data_source.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/usecases/home_usecases.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

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
    () => SettingsLocalDataSourceImpl(
      Hive.box<ProfileModel>(AppConstants.settingsBoxName),
    ),
  );
  getit.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(getit()),
  );
  getit.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getit(), getit(), getit()),
  );

  // Home
  getit.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(
      Hive.box<SemesterModel>(AppConstants.semestersBoxName),
      Hive.box<SubjectModel>(AppConstants.subjectsBoxName),
      Hive.box<SyncActionModel>(AppConstants.syncQueueBoxName),
    ),
  );
  getit.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getit()),
  );
  getit.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getit(), getit(), getit()),
  );

  // AI Advisor
  getit.registerLazySingleton<AiAdvisorRemoteDataSource>(
    () => AiAdvisorRemoteDataSourceImpl(getit()),
  );
  getit.registerLazySingleton<AiAdvisorRepository>(
    () => AiAdvisorRepositoryImpl(getit(), getit()),
  );

  getit.registerLazySingleton(() => GetAiAnalysisUseCase(getit()));

  // UseCases
  getit.registerLazySingleton(() => GetProfileUseCase(getit()));
  getit.registerLazySingleton(() => UpdateGradingScaleUseCase(getit()));

  getit.registerLazySingleton(() => GetHomeDataUseCase(getit()));
  getit.registerLazySingleton(() => ManageSemesterUseCase(getit()));
  getit.registerLazySingleton(() => ManageSubjectUseCase(getit()));
  getit.registerLazySingleton(() => CalculateAndSyncCGPAUseCase(getit()));

  // Cubits
  getit.registerFactory<SplashCubit>(() => SplashCubit(getit()));
  getit.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  getit.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getit()));
  getit.registerFactory<MainLayoutCubit>(() => MainLayoutCubit());

  getit.registerFactory<HomeCubit>(
    () => HomeCubit(getit(), getit(), getit(), getit(), getit()),
  );

  getit.registerFactory<SettingsCubit>(
    () => SettingsCubit(getit(), getit(), getit()),
  );

  getit.registerFactory<AiAdvisorCubit>(() => AiAdvisorCubit(getit()));
}
