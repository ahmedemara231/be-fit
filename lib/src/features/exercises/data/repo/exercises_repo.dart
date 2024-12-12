import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/extensions/future.dart';
import 'package:be_fit/src/core/helpers/global_data_types/exercises.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../statistics/data/data_source/models/record.dart';
import '../data_source/exercises_data_source.dart';
import '../data_source/models/add_custom_exercise.dart';
abstract class ExercisesRepo{
  Future<Result<List<Exercises>, FirebaseError>> getExercises(String muscleName);

  Future<Result<String, FirebaseError>> deleteExercise(Exercises exercise);

  Future<Result<String, FirebaseError>> deleteRec();

  Future<Result<String, FirebaseError>> setRec();

  Future<Result<List<MyRecord>, FirebaseError>> getRecords();
  Future<Result<CustomExercises, FirebaseError>> addNewCustomExercise({
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs
  });
}

class ExercisesRepoImpl extends ExercisesRepo{
  ExercisesDataSource dataSource;

  ExercisesRepoImpl(this.dataSource);

  @override
  Future<Result<List<Exercises>, FirebaseError>> getExercises(String muscleName) async {
    return await dataSource
        .getAllExercises(muscleName)
        .handleFirebaseCalls();
  }

  @override
  Future<Result<String, FirebaseError>> deleteExercise(Exercises exercise) async {
    return await dataSource
        .deleteExercise(exercise)
        .handleFirebaseCalls();
  }

  @override
  Future<Result<String, FirebaseError>> deleteRec() async {
    return await dataSource
        .deleteRec()
        .handleFirebaseCalls();
  }

  @override
  Future<Result<String, FirebaseError>> setRec() async {
    return await dataSource
        .setRec()
        .handleFirebaseCalls();
  }

  @override
  Future<Result<List<MyRecord>, FirebaseError>> getRecords() async {
    return await dataSource
        .getRecords()
        .handleFirebaseCalls();
  }

  @override
  Future<Result<CustomExercises, FirebaseError>> addNewCustomExercise({
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs
  }) async {
    return await dataSource
        .addNewCustomExercise(addCustomExerciseModel: addCustomExerciseModel, inputs: inputs)
        .handleFirebaseCalls();
  }
}