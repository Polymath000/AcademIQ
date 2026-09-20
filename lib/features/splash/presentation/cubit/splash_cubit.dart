import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SupabaseClient _supabaseClient;

  SplashCubit(this._supabaseClient) : super(SplashInitial());

  Future<void> initSplash() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    final user = _supabaseClient.auth.currentUser;
    if (user != null) {
      emit(SplashNavigateToHome());
    } else {
      final hasSeenOnboarding = Hive.box(
        'prefs',
      ).get('hasSeenOnboarding', defaultValue: false) as bool;
      if (!hasSeenOnboarding) {
        emit(SplashNavigateToOnboarding());
      } else {
        emit(SplashNavigateToLogin());
      }
    }
  }
}
