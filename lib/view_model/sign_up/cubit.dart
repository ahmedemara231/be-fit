import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../model/remote/firebase_service/auth_service/implementation.dart';
import '../../model/remote/firebase_service/auth_service/interface.dart';
import '../../model/remote/firebase_service/errors.dart';
import '../../models/data_types/user.dart';

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
}