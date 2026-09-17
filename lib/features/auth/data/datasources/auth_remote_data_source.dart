import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/networking/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/login_params.dart';
import '../models/register_params.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login(LoginParams params);
  Future<UserCredential> register(RegisterParams params);
  Future<void> logout();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final NetworkInfo _networkInfo;

  AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
    this._networkInfo,
  );

  @override
  Future<UserCredential> login(LoginParams params) async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }

  @override
  Future<UserCredential> register(RegisterParams params) async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );

    final user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(params.name);
      await _firestore.collection('users').doc(user.uid).set({
        'name': params.name,
        'email': params.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return userCredential;
  }

  @override
  Future<void> logout() async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
    await _firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
