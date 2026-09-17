import 'package:firebase_auth/firebase_auth.dart';
import '../errors/failures.dart';
import '../errors/exceptions.dart';

class ApiErrorHandler {
  final String message;
  final String? code;

  ApiErrorHandler._(this.message, this.code);

  static ApiErrorHandler handle(Object error) {
    if (error is NoInternetException) {
      return ApiErrorHandler._('No internet connection. Please check your network and try again.', 'no-internet');
    }
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return ApiErrorHandler._('No user found for that email.', error.code);
        case 'wrong-password':
          return ApiErrorHandler._('Wrong password provided.', error.code);
        case 'email-already-in-use':
          return ApiErrorHandler._('The account already exists for that email.', error.code);
        case 'invalid-email':
          return ApiErrorHandler._('The email address is badly formatted.', error.code);
        case 'weak-password':
          return ApiErrorHandler._('The password provided is too weak.', error.code);
        case 'network-request-failed':
          return ApiErrorHandler._('Network error. Please check your internet connection.', error.code);
        default:
          return ApiErrorHandler._(error.message ?? 'Authentication failed.', error.code);
      }
    } else if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return ApiErrorHandler._('You do not have permission to execute this action.', error.code);
        case 'unavailable':
          return ApiErrorHandler._('The service is currently unavailable. Check your connection.', error.code);
        default:
          return ApiErrorHandler._(error.message ?? 'A database error occurred.', error.code);
      }
    }

    return ApiErrorHandler._('An unexpected error occurred.', null);
  }

  Failure toFailure() {
    return ServerFailure(message);
  }
}
