import 'dart:async';

import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/remote/firebase_service/error_handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multiple_result/src/result.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../constants/constants.dart';
import '../../../../models/widgets/modules/toast.dart';
import '../../../../view/BottomNavBar/bottom_nav_bar.dart';
import '../../../local/cache_helper/shared_prefs.dart';
import 'errors.dart';
import 'interface.dart';

class FirebaseRegisterCall extends AuthService
{
  @override
  Future<Result<UserCredential, SecondFirebaseError>> callFirebaseAuth({
    required String email,
    required String password,
  })async{

    final connectivityResult = await Connectivity().checkConnectivity();

    switch(connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        try{
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password
          );

          return Result.success(userCredential);

        } on FirebaseAuthException catch (e) {
          return Result.error(FirebaseAuthenticationException(e.code));
        }
      default:
        return Result.error(NetworkException('Please Check your connection and try again'));
    }
  }

  @override
  void handleSuccess(BuildContext context,{required UserCredential userCredential}) async{

    await storeDataOnFirebase(userCredential);

    await cacheData(userCredential).whenComplete(()
    {
      context.removeOldRoute(
          ShowCaseWidget(
            builder: (context) {
              return const BottomNavBar();
              },
          )
      );

      MyToast.showToast(
        context,
        msg: 'Welcome Coach!',
        color: Constants.appColor,
      );
    });
  }

  Future<void> cacheData(UserCredential userCredential)async
  {
    await CacheHelper.getInstance().setData(
      key: 'userData',
      value: [
        '${userCredential.user?.uid}',
        '${userCredential.user?.email!.split("@").first}',
        '${userCredential.user?.email!}',
      ],
    );
    await CacheHelper.getInstance().setData(
      key: 'isBeginner',
      value: true
    );

    await CacheHelper.getInstance().setData(
        key: 'showCaseDone',
        value: false
    );

    Timer(const Duration(seconds: 10), ()async {
      await CacheHelper.getInstance().setData(
          key: 'showCaseDone',
          value: true
      );
    });
  }

  Future<void> storeDataOnFirebase(UserCredential userCredential)async
  {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .set(
      {
        'email' : userCredential.user?.email,
      },
    );
  }
}

class FirebaseLoginCall extends AuthService
{
  @override
  Future<Result<UserCredential, SecondFirebaseError>> callFirebaseAuth({
    required String email,
    required String password,
  })async{

    final connectivityResult = await Connectivity().checkConnectivity();

    switch(connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        try{
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password
          );

          return Result.success(userCredential);

        } on FirebaseAuthException catch (e) {
          return Result.error(FirebaseAuthenticationException(e.code));
        }
      default:
        return Result.error(NetworkException('Please Check your connection and try again'));
    }
  }

  Future<void> cacheData(UserCredential userCredential)async
  {
    await CacheHelper.getInstance().setData(
      key: 'userData',
      value: [
        '${userCredential.user?.uid}',
        '${userCredential.user?.email!.split("@").first}',
        '${userCredential.user?.email!}',
      ],
    );
  }

  @override
  void handleSuccess(BuildContext context,{required UserCredential userCredential}) {

    cacheData(userCredential);

    context.removeOldRoute(const BottomNavBar());

    MyToast.showToast(
      context,
      msg: 'Welcome Coach!',
      color: Constants.appColor,
    );
  }
}

class GoogleSignInCall extends GoogleAuth
{
  @override
  Future<Result<UserCredential, FirebaseError>> signInWithGoogle(BuildContext context)async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if(googleUser == null)
      {
        return Result.error(Unavailable(''));
      }
      else{
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential user =  await FirebaseAuth.instance.signInWithCredential(credential);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .set(
          {
            'name' : user.user!.displayName,
            'email' : user.user!.email,
          },
        );
        return Result.success(user);
      }
    } on FirebaseAuthException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }
}
