import 'package:get_it/get_it.dart';

import '../../../core/data_source/remote/firebase_service/auth_service/implementation.dart';
import '../../../core/data_source/remote/firebase_service/auth_service/interface.dart';

class ChangeDependencies{
  static void change(AuthServiceInterface instance){
    GetIt.instance.unregister<AuthServiceInterface>();
    GetIt.instance.registerLazySingleton<AuthServiceInterface>(() => instance);
  }
}