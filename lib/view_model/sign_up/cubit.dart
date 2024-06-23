import 'dart:io';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../model/remote/firebase_service/auth_service/implementation.dart';
import '../../model/remote/firebase_service/auth_service/interface.dart';
import '../../model/remote/firebase_service/errors.dart';
import '../../models/data_types/user.dart';
import '../../models/widgets/modules/snackBar.dart';

class SignUpCubit extends Cubit<SignUpStates>
{
  SignUpCubit(super.initialState);
  static SignUpCubit getInstance(context) => BlocProvider.of(context);

  AuthService signUpService = FirebaseRegisterCall();
  Future<void> signUp({
    required Trainee user,
    required context,
})async
  {
    emit(SignUpLoadingState());

    Result<UserCredential,FirebaseError> result = await signUpService.callFirebaseAuth(
        email: user.email, password: user.password,
    );

    if(result.isSuccess())
      {
        signUpService.handleSuccess(context, userCredential: result.getOrThrow());
        emit(SignUpSuccessState());
      }
    else{
      signUpService.handleError(context, result.tryGetError()?.message);
      emit(SignUpErrorState());
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