import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../models/widgets/modules/toast.dart';
import '../errors.dart';

abstract class AuthService
{
  Future<Result<UserCredential,FirebaseError2>> callFirebaseAuth({
    required String email,
    required String password,
  });

  void handleSuccess(BuildContext context,{required UserCredential userCredential});

  void handleError(context, String? errorMessage){
    MyToast.showToast(context, msg: errorMessage!,color: Colors.red);
  }
}