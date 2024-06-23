import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import '../errors.dart';

abstract class FireStorageService
{
  Future<Result<Reference,FirebaseError>> callFireStorage({
    required String refName,
    required String childName,
});

  void handleError(BuildContext context, {String? errorMessage});
}