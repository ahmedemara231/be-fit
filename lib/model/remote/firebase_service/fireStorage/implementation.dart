import 'package:be_fit/model/remote/firebase_service/error_handling.dart';
import 'package:be_fit/model/remote/firebase_service/fireStorage/interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../constants/constants.dart';
import '../../../../models/data_types/add_custom_exercise.dart';
import '../../../../models/data_types/exercises.dart';
import '../../../../models/widgets/modules/toast.dart';
import '../../../local/cache_helper/shared_prefs.dart';

class FireStorageCall extends FireStorageService
{
  @override
  Future<Result<CustomExercises, FirebaseError>> callFireStorage(BuildContext context,{
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs,
  })async{
    try{
      final val = await FirebaseStorage.instance
          .ref(inputs.refName)
          .child(inputs.childName)
          .putFile(inputs.selectedExerciseImage);

      final imageUrl = await val.ref.getDownloadURL();

      final value = await FirebaseFirestore.instance
          .collection('users').doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('customExercises')
          .add(addCustomExerciseModel.toJson(imageUrl));

      final exercise = CustomExercises(
        image: [imageUrl],
        name: addCustomExerciseModel.name,
        docs: addCustomExerciseModel.description,
        muscleName: addCustomExerciseModel.muscle,
        id: value.id,
        isCustom: true,
        video: '',
      );
      return Result.success(exercise);
    }on FirebaseException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  @override
  void handleError(BuildContext context, {String? errorMessage}) {
    MyToast.showToast(context, msg: errorMessage??'Try Again Later',color: Constants.appColor);
  }
}