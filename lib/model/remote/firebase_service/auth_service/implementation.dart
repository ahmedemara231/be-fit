import 'package:be_fit/extensions/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/src/result.dart';
import '../../../../constants/constants.dart';
import '../../../../models/widgets/modules/toast.dart';
import '../../../../view/BottomNavBar/bottom_nav_bar.dart';
import '../../../local/cache_helper/shared_prefs.dart';
import '../errors.dart';
import 'interface.dart';

class FirebaseRegisterCall extends AuthService
{
  @override
  Future<Result<UserCredential, FirebaseError>> callFirebaseAuth({
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
      context.removeOldRoute(BottomNavBar());

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
  Future<Result<UserCredential, FirebaseError>> callFirebaseAuth({
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

    context.removeOldRoute(BottomNavBar());

    MyToast.showToast(
      context,
      msg: 'Welcome Coach!',
      color: Constants.appColor,
    );
  }
}

