class AuthStates {}

class SignUpLoadingState extends AuthStates {}

class SignUpSuccessState extends AuthStates {}

class SignUpErrorState extends AuthStates {
  String? errorMsg;
  SignUpErrorState(this.errorMsg);
}

class LoginInitialState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class GoBackState extends AuthStates{}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  String? errorMsg;
  LoginErrorState(this.errorMsg);
}

class SetPasswordVisibility extends AuthStates{}

class ForgotPasswordLoadingState extends AuthStates {}

class ForgotPasswordSuccessState extends AuthStates {}

class ForgotPasswordErrorState extends AuthStates {
  String errorMsg;
  ForgotPasswordErrorState(this.errorMsg);
}
