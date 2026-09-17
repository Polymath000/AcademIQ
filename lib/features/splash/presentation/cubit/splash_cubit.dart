import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final FirebaseAuth _firebaseAuth;

  SplashCubit(this._firebaseAuth) : super(SplashInitial());

  Future<void> initSplash() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}
