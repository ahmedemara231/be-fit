import 'dart:io';
import 'package:be_fit/src/core/helpers/methods/image_selector.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/data_source/remote/firebase_service/fireStorage/interface.dart';
import '../../../../core/data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../../statistics/data/data_source/models/record.dart';
import 'models/add_custom_exercise.dart';

class ExercisesDataSource{
  ExercisesInterface interface;
  StorageService service;
  
  ExercisesDataSource({required this.interface, required this.service});
  
  Future<List<Exercises>> getAllExercises(String muscleName) async {
    return await interface.getExercises(muscleName);
  }
  
  Future<String> setRec()async{
    return interface.setRecords();
  }

  Future<List<MyRecord>> getRecords()async{
    return interface.getRecords();
  }

  Future<String> deleteRec()async{
    return interface.deleteRecord();
  }

  Future<String> deleteExercise(Exercises exercise)async{
    return interface.deleteExercise(exercise);
  }

  Future<File?> selectImage(ImageSource source)async{
    return ImageSelector.selectImage(source);
  }

  Future<CustomExercises> addNewCustomExercise({
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs
  })async{
    return await service.addNewCustomExercise(
        addCustomExerciseModel: addCustomExerciseModel,
        inputs: inputs
    );
  }
}