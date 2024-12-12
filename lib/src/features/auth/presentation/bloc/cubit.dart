import 'dart:async';
import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/implementation.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/interface.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/features/auth/presentation/bloc/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../data/data_source/models/user.dart';
import '../../data/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthStates>
{
  AuthCubit(this.authServiceRepo) : super(LoginInitialState());
  factory AuthCubit.getInstance(context) => BlocProvider.of(context);

  AuthRepo authServiceRepo;

  Future<void> callFirebaseAuth({
    required Trainee trainee,
  })async
  {
    if(authServiceRepo.dataSource.service is FirebaseLoginCall){
      await login(user: trainee);
    }else{
      await signUp(user: trainee);
    }
  }

  Future<void> login({
    required Trainee user
  })async
  {
    emit(LoginLoadingState());
    Result<UserCredential,FirebaseError> result = await authServiceRepo.callFirebaseAuth(
        user
    );

    if(result.isSuccess()) {
        emit(LoginSuccessState());
    }
    else{
      emit(LoginErrorState(
          result.tryGetError()?.message
      ));
    }
  }

  Future<void> signUp({
    required Trainee user,
  })async
  {
    emit(SignUpLoadingState());

    Result<UserCredential,FirebaseError> result = await authServiceRepo.callFirebaseAuth(
      user
    );

    if(result.isSuccess()) {
      emit(SignUpSuccessState());
    }
    else{
      emit(SignUpErrorState(
          result.tryGetError()?.message
      ));
    }
  }

  bool isVisible = true;
  void setPasswordVisibility()
  {
    isVisible = !isVisible;
    emit(SetPasswordVisibility());
  }

  Future<void> forgotPassword(String email)async
  {
    emit(ForgotPasswordLoadingState());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
          .then((value) {
        emit(ForgotPasswordSuccessState());
      }).catchError(( e){
        emit(ForgotPasswordErrorState(e.message.toString()));
      });
  }

  Future<void> signInWithGoogle(GoogleAuthInterface signIn) async {
    emit(LoginLoadingState());
    final result = await authServiceRepo.signInWithGoogle();
    if(result.isSuccess()){
      emit(LoginSuccessState());
    }else{
      emit(LoginErrorState(
          result.tryGetError()?.message
      ));
    }
  }
}