import 'package:be_fit/model/remote/firebase_service/error_handling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../models/widgets/modules/toast.dart';
import 'errors.dart';

abstract class AuthService
{
  Future<Result<UserCredential,SecondFirebaseError>> callFirebaseAuth({
    required String email,
    required String password,
  });

  void handleSuccess(BuildContext context,{required UserCredential userCredential});

  void handleError(context, String? errorMessage){
    MyToast.showToast(context, msg: errorMessage!,color: Colors.red);
  }
}

abstract class GoogleAuth
{
  Future<Result<UserCredential, FirebaseError>> signInWithGoogle(BuildContext context);
}