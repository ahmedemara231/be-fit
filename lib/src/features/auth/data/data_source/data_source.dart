import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data_source/models/user.dart';

class AuthDataSource{
  AuthServiceInterface service;
  GoogleAuthInterface googleAuthInterface;

  AuthDataSource({required this.service, required this.googleAuthInterface});
  Future<UserCredential> callFirebaseAuth(Trainee trainee)async{
    return await service.callFirebaseAuth(email: trainee.email, password: trainee.password);
  }

  Future<UserCredential> signInWithGoogle()async{
    return await googleAuthInterface.signInWithGoogle();
  }
}