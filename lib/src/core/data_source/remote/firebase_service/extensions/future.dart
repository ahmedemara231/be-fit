import 'package:multiple_result/multiple_result.dart';

import '../error_handling/base_error.dart';

extension ErrorHandler<T extends Object> on Future<T> {
  Future<Result<T, FirebaseError>> handleFirebaseCalls()async{
    try{
      final T result = await this;
      return Result.success(result);
    } on FirebaseError catch(e){
      return Result.error(e);
    }
  }
}