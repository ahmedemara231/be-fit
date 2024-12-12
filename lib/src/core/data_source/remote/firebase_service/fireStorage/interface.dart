import '../../../../../features/exercises/data/data_source/models/add_custom_exercise.dart';
import '../../../../helpers/global_data_types/exercises.dart';

abstract class StorageService {
  Future<CustomExercises> addNewCustomExercise({
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs,
});
}