import 'package:flutter/foundation.dart';
import '../networking/supabase_interceptor.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/utls/setup_service_locator.dart';
import '../../features/settings/data/models/profile_model.dart';
import '../../features/settings/data/models/grading_scale_model.dart';
import '../../features/home/data/models/semester_model.dart';
import '../../features/home/data/models/subject_model.dart';
import '../../features/home/data/models/sync_action_model.dart';
import '../../features/home/domain/repositories/home_repository.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ProfileHiveAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(GradingScaleHiveAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(SemesterHiveAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(SubjectHiveAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(SyncActionHiveAdapter());
      }

      await dotenv.load(fileName: ".env");
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
        httpClient: kDebugMode ? SupabaseInterceptor() : null,
      );

      Future<void> openHiveBox<T>(String name) async {
        try {
          await Hive.openBox<T>(name);
        } catch (e) {
          try {
            await Hive.deleteBoxFromDisk(name);
          } catch (_) {}
          await Hive.openBox<T>(name);
        }
      }

      await openHiveBox<ProfileModel>('settings_box');
      await openHiveBox<SemesterModel>('semesters_box');
      await openHiveBox<SubjectModel>('subjects_box');
      await openHiveBox<SyncActionModel>('sync_queue_box');

      await setupServiceLocator();

      final homeRepository = getit<HomeRepository>();
      await homeRepository.processSyncQueue();

      return await Future.value(true);
    } catch (e) {
      return await Future.value(false);
    }
  });
}
