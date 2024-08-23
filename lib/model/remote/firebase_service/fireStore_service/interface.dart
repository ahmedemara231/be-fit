import 'package:be_fit/model/remote/firebase_service/errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class FireStoreService
{
  Future<Result<CollectionReference,FirebaseError2>> callFireStore(String collectionName);

  void handleError(BuildContext context, {String? errorMessage});
}