import 'dart:developer';
import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/error_handling/errors.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler{
  static FirebaseError handle(FirebaseAuthException e){
    log(e.code.toString());
    return FirebaseAuthError(e.message.toString());
  }
}