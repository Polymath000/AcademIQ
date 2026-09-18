import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/networking/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/login_params.dart';
import '../models/register_params.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginParams params);
  Future<AuthResponse> register(RegisterParams params);
  Future<void> logout();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final NetworkInfo _networkInfo;

  AuthRemoteDataSourceImpl(
    this._supabaseClient,
    this._networkInfo,
  );

  @override
  Future<AuthResponse> login(LoginParams params) async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
    return await _supabaseClient.auth.signInWithPassword(
      email: params.email,
      password: params.password,
    );
  }

  @override
  Future<AuthResponse> register(RegisterParams params) async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
    
    // With Supabase, we can pass additional user metadata directly during signup.
    // However, since we are moving the defaults (like gradingScale) to Postgres Triggers,
    // we only need to pass the name. The Postgres Trigger will handle the rest!
    final response = await _supabaseClient.auth.signUp(
      email: params.email,
      password: params.password,
      data: {
        'full_name': params.name,
      },
    );

    return response;
  }

  @override
  Future<void> logout() async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
    await _supabaseClient.auth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }
}
