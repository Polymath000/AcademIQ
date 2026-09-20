import 'package:flutter/foundation.dart';

import 'core/networking/supabase_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/home/data/models/sync_action_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gpa_calculator/gpa_calculator_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workmanager/workmanager.dart';

import 'core/utls/setup_service_locator.dart';
import 'features/settings/data/models/profile_model.dart';
import 'features/settings/data/models/grading_scale_model.dart';
import 'features/home/data/models/semester_model.dart';
import 'features/home/data/models/subject_model.dart';
import 'core/background_sync/background_sync_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, //TODO: Set to false in production
  );
  GoogleFonts.config.allowRuntimeFetching = false;

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    httpClient: kDebugMode ? SupabaseInterceptor() : null,
  );
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProfileHiveAdapter());
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(GradingScaleHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(SemesterHiveAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(SubjectHiveAdapter());
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(SyncActionHiveAdapter());
  }
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

  await openHiveBox<ProfileModel>(AppConstants.settingsBoxName);
  await openHiveBox<SemesterModel>(AppConstants.semestersBoxName);
  await openHiveBox<SubjectModel>(AppConstants.subjectsBoxName);
  await openHiveBox<SyncActionModel>(AppConstants.syncQueueBoxName);
  await openHiveBox<dynamic>('prefs');

  await setupServiceLocator();

  runApp(const GpaCalculatorApp());
}
