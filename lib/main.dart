import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpa_calculator/gpa_calculator_app.dart';

import 'firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';

import 'core/utls/setup_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();

  runApp(const GpaCalculatorApp());
}
