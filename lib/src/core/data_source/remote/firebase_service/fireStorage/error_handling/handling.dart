import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'errors.dart';

class StorageErrorHandling{

  static StorageErrorHandling? instance;

  StorageErrorHandling._();

  static StorageErrorHandling getInstance(){
    return instance ??= StorageErrorHandling._();
  }

  FirebaseError handle(FirebaseException e){
    switch(e.code){
      case 'storage/unknown':
        return StorageUnknown(e.message.toString());

      case 'storage/object-not-found':
        return StorageObjectNotFound(e.message.toString());

      case 'storage/bucket-not-found':
        return StorageBucketNotFound(e.message.toString());

      case 'storage/project-not-found':
        return StorageProjectNotFound(e.message.toString());

      case 'storage/quota-exceeded':
        return StorageQuotaExceeded(e.message.toString());

      case 'storage/unauthenticated':
        return StorageUnauthenticated(e.message.toString());

      case 'storage/unauthorized':
        return StorageUnauthorized(e.message.toString());

      case 'storage/retry-limit-exceeded':
        return StorageRetryLimitExceeded(e.message.toString());

      case 'storage/invalid-checksum':
        return StorageInvalidChecksum(e.message.toString());

      case 'storage/canceled':
        return StorageCanceled(e.message.toString());

      case 'storage/invalid-event-name':
        return StorageInvalidEventName(e.message.toString());

      case 'storage/invalid-url':
        return StorageInvalidUrl(e.message.toString());

      case 'storage/invalid-argument':
        return StorageInvalidArgument(e.message.toString());

      case 'storage/no-default-bucket':
        return StorageNoDefaultBucket(e.message.toString());

      case 'storage/cannot-slice-blob':
        return StorageCannotSliceBlob(e.message.toString());

      case 'storage/server-file-wrong-size':
        return StorageServerFileWrongSize(e.message.toString());

      default:
        return DefaultError(e.message.toString());
    }
  }
}