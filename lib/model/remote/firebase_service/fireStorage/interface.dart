import 'package:be_fit/models/data_types/exercises.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../models/data_types/add_custom_exercise.dart';
import '../error_handling.dart';

abstract class FireStorageService
{
  Future<Result<CustomExercises,FirebaseError>> callFireStorage(BuildContext context, {
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs,
});

  void handleError(BuildContext context, {String? errorMessage});
}