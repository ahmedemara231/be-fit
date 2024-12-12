import 'package:cloud_firestore/cloud_firestore.dart';

import '../../error_handling/base_error.dart';
import 'firestore_errors.dart';

class StoreErrorHandler
{
  static StoreErrorHandler? errorHandler;
  StoreErrorHandler();

  static StoreErrorHandler getInstance()
  {
    return errorHandler ??= StoreErrorHandler();
  }

  FirebaseError handle(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
        return Unavailable(ErrorCode.unavailable);

      case 'permission-denied':
        return PermissionDenied(ErrorCode.permissionDenied);

      case 'resource-exhausted':
        return ResourceExhausted(ErrorCode.resourceExhausted);

      case 'aborted':
        return Aborted(ErrorCode.aborted);

      default:
        return DefaultError(ErrorCode.defaultError);
    }
  }
}