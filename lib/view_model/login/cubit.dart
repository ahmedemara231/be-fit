import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/models/widgets/modules/toast.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import '../../model/remote/firebase_service/auth_service/implementation.dart';
import '../../model/remote/firebase_service/auth_service/interface.dart';
import '../../model/remote/firebase_service/errors.dart';
import '../../view/BottomNavBar/bottom_nav_bar.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(super.initialState);
  static LoginCubit getInstance(context) => BlocProvider.of(context);

  AuthService loginService = FirebaseLoginCall();

  Future<void> login({
    required context,
    required Trainee user
  })async
  {
    emit(LoginLoadingState());
    Result<UserCredential,FirebaseError2> result = await loginService.callFirebaseAuth(
        email: user.email,
        password: user.password
    );

    if(result.isSuccess())
      {
        loginService.handleSuccess(context, userCredential: result.getOrThrow());
        emit(LoginSuccessState());
      }
    else{
      loginService.handleError(context, result.tryGetError()?.message);
      emit(LoginErrorState());
    }
  }

  void handleLoginErrors(context,Exception e)
  {
    AnimatedSnackBar.material(
        'Try again later',
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom
    ).show(context);
  }

  bool isVisible = true;
  void setPasswordVisibility()
  {
    isVisible = !isVisible;
    print(isVisible);
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
    } on FirebaseAuthException catch(e)
    {
      emit(ForgotPasswordErrorState());
      handleLoginErrors(context, e);
    }
  }

  Future<void> signInWithGoogle(BuildContext context, GoogleAuth signIn) async {
    emit(LoginLoadingState());
    final result = await signIn.signInWithGoogle(context);
    if(result.isSuccess())
      {
        await finishGoogleSignIn(context, result.getOrThrow());
        emit(LoginSuccessState());
      }
    else{
      emit(LoginErrorState());
    }
  }

  Future<void> finishGoogleSignIn(BuildContext context, UserCredential user)async
  {
    await CacheHelper.getInstance().setData(key: 'isGoogleUser', value: true);
    await CacheHelper.getInstance().setData(
      key: 'userData',
      value: <String>[
        user.user!.uid,
        user.user!.displayName!,
        user.user!.email!
      ],
    ).whenComplete(() {
      context.removeOldRoute(const BottomNavBar());
      MyToast.showToast(
        context,
        msg: 'Welcome Coach!',
        color: Constants.appColor,
      );
    });
  }
}