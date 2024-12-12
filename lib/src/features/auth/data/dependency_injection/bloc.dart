import 'package:get_it/get_it.dart';

import '../../../../core/data_source/remote/firebase_service/auth_service/implementation.dart';
import '../../../../core/data_source/remote/firebase_service/auth_service/interface.dart';
import '../../presentation/bloc/cubit.dart';
import '../data_source/data_source.dart';
import '../repo/auth_repo.dart';

class AuthDependencies{

  static final authServiceLocator = GetIt.instance;
  static void setBloc(){
    authServiceLocator.registerLazySingleton<AuthCubit>(() => AuthCubit(
        AuthRepo(
            AuthDataSource(
                service: authServiceLocator.get<AuthServiceInterface>(),
                googleAuthInterface: GoogleSignInCall()
            )
        )
    ));
    authServiceLocator.registerLazySingleton<AuthServiceInterface>(() => FirebaseLoginCall());
  }
}