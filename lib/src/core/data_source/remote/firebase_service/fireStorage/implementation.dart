import 'package:be_fit/src/core/data_source/remote/firebase_service/fireStorage/error_handling/handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../../features/exercises/data/data_source/models/add_custom_exercise.dart';
import '../../../../helpers/global_data_types/exercises.dart';
import '../../../local/cache_helper/shared_prefs.dart';
import 'interface.dart';

class FireStorageCall extends StorageService {
  @override
  Future<CustomExercises> addNewCustomExercise({
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs
  })async {
    try{
          final val = await FirebaseStorage.instance
              .ref(inputs.refName)
              .child(inputs.childName)
              .putFile(inputs.selectedExerciseImage);
          final imageUrl = await val.ref.getDownloadURL();

          final value = await writeNewCustomExerciseInFireStore(
              addCustomExerciseModel: addCustomExerciseModel,
              imageUrl: imageUrl
          );

          final exercise = CustomExercises(
            image: [imageUrl],
            name: addCustomExerciseModel.name,
            docs: addCustomExerciseModel.description,
            muscleName: addCustomExerciseModel.muscle,
            id: value.id,
            isCustom: true,
            video: '',
          );
          return exercise;
        }on FirebaseException catch(e) {
          final error = StorageErrorHandling.getInstance().handle(e);
          throw error;
        }
  }

  Future<DocumentReference> writeNewCustomExerciseInFireStore({
    required AddCustomExerciseModel addCustomExerciseModel,
    required String imageUrl
  }) async {
    final value = await FirebaseFirestore.instance
        .collection('users').doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
        .collection('customExercises')
        .add(addCustomExerciseModel.toJson(imageUrl));
    return value;
  }
}