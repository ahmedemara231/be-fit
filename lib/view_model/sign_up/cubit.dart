import 'dart:io';
import 'package:be_fit/constants.dart';
import 'package:be_fit/view/auth/login/login.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data_types/user.dart';
import '../../models/widgets/modules/snackBar.dart';

class SignUpCubit extends Cubit<SignUpStates>
{
  SignUpCubit(super.initialState);
  static SignUpCubit getInstance(context) => BlocProvider.of(context);

  Future<void> signUp({
    required Trainee user,
    required context,
})async
  {
    try {
      emit(SignUpLoadingState());
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      ).then((value)async
      {
        if(value.user == null)
          {
            MySnackBar.showSnackBar(
                context: context,
                message: 'Please try again later',
            );
            emit(SignUpErrorState());
          }
        else{

          await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user?.uid)
          .set(
              {
                'name' : user.name,
                'email' : user.email,
                'phone' : user.phone,
              },
          ).then((value)
          {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ), (route) => false,
            );
            emit(SignUpSuccessState());
          });
        }
      });
    } on Exception catch (e) {
      emit(SignUpErrorState());
      handleErrors(context, e);
    }
  }

  void handleErrors(context,Exception e)
  {
    if(e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          MySnackBar.showSnackBar(
              context: context,
              message: 'The password provided is too weak.',
              color: Constants.appColor
          );
        }
        else if (e.code == 'email-already-in-use') {
          MySnackBar.showSnackBar(
              context: context,
              message: 'The account already exists for that email.',
              color: Constants.appColor
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
            message: 'Please try again later',
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
    else{
      MySnackBar.showSnackBar(
        context: context,
        message: 'Please try again later',
        color: Constants.appColor
      );
    }
  }
}