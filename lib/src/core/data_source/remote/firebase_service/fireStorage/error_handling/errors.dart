import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';

class StorageUnknown extends FirebaseError{
  StorageUnknown(super.message);
}
class StorageObjectNotFound extends FirebaseError{
  StorageObjectNotFound(super.message);
}
class StorageBucketNotFound extends FirebaseError{
  StorageBucketNotFound(super.message);
}
class StorageProjectNotFound extends FirebaseError{
  StorageProjectNotFound(super.message);
}
class StorageQuotaExceeded extends FirebaseError{
  StorageQuotaExceeded(super.message);
}
class StorageUnauthenticated extends FirebaseError{
  StorageUnauthenticated(super.message);
}
class StorageUnauthorized extends FirebaseError{
  StorageUnauthorized(super.message);
}
class StorageRetryLimitExceeded extends FirebaseError{
  StorageRetryLimitExceeded(super.message);
}
class StorageInvalidChecksum extends FirebaseError{
  StorageInvalidChecksum(super.message);
}
class StorageCanceled extends FirebaseError{
  StorageCanceled(super.message);
}
class StorageInvalidEventName extends FirebaseError{
  StorageInvalidEventName(super.message);
}
class StorageInvalidUrl extends FirebaseError{
  StorageInvalidUrl(super.message);
}
class StorageInvalidArgument extends FirebaseError{
  StorageInvalidArgument(super.message);
}
class StorageNoDefaultBucket extends FirebaseError{
  StorageNoDefaultBucket(super.message);
}
class StorageCannotSliceBlob extends FirebaseError{
  StorageCannotSliceBlob(super.message);
}
class StorageServerFileWrongSize extends FirebaseError{
  StorageServerFileWrongSize(super.message);
}
class DefaultError extends FirebaseError{
  DefaultError(super.message);
}

