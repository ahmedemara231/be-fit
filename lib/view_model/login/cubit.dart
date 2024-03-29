import 'dart:io';
import 'package:be_fit/constants.dart';
import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/models/widgets/modules/toast.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/widgets/modules/snackBar.dart';
import '../../view/BottomNavBar/bottomNavBar.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(super.initialState);
  static LoginCubit getInstance(context) => BlocProvider.of(context);

  Future<void> login({
    required Trainee user,
    required context,
  })async
  {
    emit(LoginLoadingState());
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      ). then((value)async
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
      await CacheHelper.getInstance().handleUserData(
          userData:
          [
            user.id!,
            user.name!,
          ],
      ).then((value)
      {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ), (route) => false,
        );

        MyToast.showToast(
          context,
          msg: 'Welcome Coach!',
          color: Constants.appColor,
        );
        emit(LoginSuccessState());
      });
    });
  });
    }on Exception catch(e)
    {
      emit(LoginErrorState());
      handleLoginErrors(context, e);
    }
  }

  void handleLoginErrors(context,Exception e)
  {
    if(e is FirebaseAuthException)
    {
      if(e.code == 'invalid-credential') {
        MySnackBar.showSnackBar(
          context: context,
          message: 'Wrong email or password',
          color: Constants.appColor,
        );
      }
      else if(e.code == 'network-request-failed'){
        MySnackBar.showSnackBar(
          context: context,
          message: 'Check your internet connection and try again',
          color: Constants.appColor,
        );
      }
      else{
        MySnackBar.showSnackBar(
          context: context,
          message: 'Try again later',
          color: Constants.appColor,
        );
      }
    }
    else if(e is SocketException) {
      MySnackBar.showSnackBar(
        context: context,
        message: 'Check your internet connection and try again',
        color: Constants.appColor,
      );
    }
    else {
      MySnackBar.showSnackBar(
        context: context,
        message: 'Try again later',
        color: Constants.appColor,
      );
    }
  }

  bool isVisible = true;
  void setPasswordVisibility()
  {
    isVisible = !isVisible;
    emit(SetPasswordVisibility());
  }

  Future<void> forgotPassword(String email,context)async
  {
    emit(ForgotPasswordLoadingState());
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email).then((value)
      {
        emit(ForgotPasswordSuccessState());
        MyToast.showToast(context, msg: 'Check your email now');
      });
    } on FirebaseAuthException
    {
      emit(ForgotPasswordErrorState());
      MySnackBar.showSnackBar(
          context: context,
          message: 'Check your internet connection and try again',
          color: Constants.appColor
      );
    }
  }

  GoogleSignIn google = GoogleSignIn();
  Future<void> signInWithGoogle(context) async {

    emit(LoginLoadingState());

    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await google.signIn();


      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if(googleUser == null)
        {
          emit(GoBackState());
        }
      else{
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        UserCredential user =  await FirebaseAuth.instance.signInWithCredential(credential);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .set(
          {
            'name' : user.user!.displayName,
            'email' : user.user!.email,
          },
        ).then((value) async
        {
          await CacheHelper.getInstance().handleUserData(
            userData:
            [
              user.user!.uid,
              user.user!.displayName!
            ],
          ).then((value)
          {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ), (route) => false,
            );

            MyToast.showToast(
              context,
              msg: 'Welcome Coach!',
              color: Constants.appColor,
            );
            emit(LoginSuccessState());
          });

          CacheHelper.getInstance().googleUser();
        });
      }
    } on Exception catch(e)
    {
      emit(LoginErrorState());
      handleLoginErrors(context, e);
    }
  }
}