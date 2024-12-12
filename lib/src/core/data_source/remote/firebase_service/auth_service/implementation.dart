import 'dart:async';
import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/error_handling/errors.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/error_handling/handling.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../local/cache_helper/shared_prefs.dart';
import 'interface.dart';

class FirebaseRegisterCall implements AuthServiceInterface
{
  @override
  Future<UserCredential> callFirebaseAuth({
    required String email,
    required String password,
  })async{

    final connectivityResult = await Connectivity().checkConnectivity();

    switch(connectivityResult) {
      case ConnectivityResult.none:
        throw NetworkError('Please Check your connection and try again');

      default:
        try{
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password
          );

          return userCredential;

        } on FirebaseAuthException catch (e) {
          final error = AuthErrorHandler.handle(e);
          throw error;
        }
    }
  }


  void handleSuccess({required UserCredential userCredential}) async{
    await storeDataOnFirebase(userCredential);
    await cacheData(userCredential);

    /*
    * context.removeOldRoute(
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
      );*/
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

class FirebaseLoginCall implements AuthServiceInterface
{
  @override
  Future<UserCredential> callFirebaseAuth({required String email, required String password})async {
    final connectivityResult = await Connectivity().checkConnectivity();

    switch(connectivityResult) {
      case ConnectivityResult.none:
        throw NetworkError('Please Check your connection and try again');

      default:
        try{
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password
          );

          await handleSuccess(userCredential: userCredential);
          return userCredential;

        }on FirebaseAuthException catch (e) {
          final error = AuthErrorHandler.handle(e);
          throw error;
        }
    }
  }

  Future<void> handleSuccess({required UserCredential userCredential})async {

    await cacheData(userCredential);

    // context.removeOldRoute(const BottomNavBar());

    // MyToast.showToast(
    //   context,
    //   msg: 'Welcome Coach!',
    //   color: Constants.appColor,
    // );
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

}

class GoogleSignInCall implements GoogleAuthInterface
{
  @override
  Future<UserCredential> signInWithGoogle()async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if(googleUser == null) {
        throw FirebaseAuthError('Canceled');
      }
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

      await handleSignInWithGoogleSuccess(user);
      return user;
    }on FirebaseAuthException catch(e)
    {
      final error = AuthErrorHandler.handle(e);
      throw error;
    }
  }

  // should use current user object
  Future handleSignInWithGoogleSuccess(UserCredential user)async{
    await CacheHelper.getInstance().setData(key: 'isGoogleUser', value: true);
    await CacheHelper.getInstance().setData(
        key: 'isBeginner',
        value: true
    );

    await CacheHelper.getInstance().setData(
        key: 'showCaseDone',
        value: true
    );

    await CacheHelper.getInstance().setData(
      key: 'userData',
      value: <String>[
        user.user!.uid,
        user.user!.displayName!,
        user.user!.email!
      ],
    );
  }
}
