import 'dart:developer';
import 'dart:io';

import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/view/auth/login/login.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/internet_connection_check/internet_connection_check.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(super.initialState);
  static LoginCubit getInstance(context) => BlocProvider.of(context);

  late Trainee user;
  Future<void> login({
    required Trainee user,
    required context,
})async
  {
    emit(LoginLoadingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email!,
          password: user.password!,
      ).then((value)async
      {
        await FirebaseFirestore.instance
        .collection('users')
        .doc(value.user?.uid)
        .get()
        .then((value)async
        {
          user = Trainee(
            email: value.data()?['email'],
            name: value.data()?['name'],
            phone: value.data()?['phone'],
            id: value.id,
          );
          print(user);
          await CacheHelper.getInstance().handleUserData(
              userData:
              [
                user.id!,
                user.name!,
              ],
          ).then((value)
          {
            emit(LoginSuccessState());
          });
        });
      });
    } on Exception catch (e)
    {
      log('$e');
      throw handleLoginErrors(context, e);
    }
  }

  Exception handleLoginErrors(context,Exception e)
  {
    if(e is FirebaseAuthException)
    {
      emit(LoginErrorState());
      if (e.code == 'user-not-found') {
        MySnackBar.showSnackBar(
          context: context,
          message: 'No user found for that email.',
          color: Colors.red,
        );
      } else if (e.code == 'wrong-password') {
        MySnackBar.showSnackBar(
          context: context,
          message: 'Wrong password provided for that user',
          color: Colors.red,
        );
      } else{
        MySnackBar.showSnackBar(
          context: context,
          message: 'Try Again later',
          color: Colors.red,
        );
      }
    }
    else if(e is SocketException)
    {
      MySnackBar.showSnackBar(
        context: context,
        message: 'Check your internet connection and try again',
        color: Colors.red,
      );
    }
    return e;
  }

  Future<void> forgotPassword(String email,context)async
  {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email).then((value)
    {
      MySnackBar.showSnackBar(
          context: context,
          message: 'Check your email',
          color: Colors.green
      );
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}