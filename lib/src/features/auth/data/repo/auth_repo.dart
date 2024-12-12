import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/extensions/future.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';
import '../data_source/data_source.dart';
import '../data_source/models/user.dart';

class AuthRepo{
  AuthDataSource dataSource;
  AuthRepo(this.dataSource);

  Future<Result<UserCredential, FirebaseError>> callFirebaseAuth(Trainee trainee) async {
    return await dataSource
        .callFirebaseAuth(trainee)
        .handleFirebaseCalls();
  }

  Future<Result<UserCredential, FirebaseError>> signInWithGoogle()async {
    return await dataSource
        .signInWithGoogle()
        .handleFirebaseCalls();
  }
}