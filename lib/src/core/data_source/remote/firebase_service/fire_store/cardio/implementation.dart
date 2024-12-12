import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/error_handling/handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../features/cardio/data/data_source/models/cardio_records.dart';
import '../../../../../../features/cardio/data/data_source/models/set_cardio_rec_model.dart';
import '../../../../../helpers/global_data_types/delete_record.dart';
import '../../../../../helpers/global_data_types/exercises.dart';
import '../../../../local/cache_helper/shared_prefs.dart';
import '../interface.dart';

class CardioImpl implements CardioExercisesInterface
{
  late List<Exercises> cardioExercises;

  @override
  Future<List<Exercises>> getExercises() async{
    try {
      List<Exercises> exercises = [];
      final response = await FirebaseFirestore.instance
          .collection('cardio')
          .get();

      for (var element in response.docs) {
        exercises.add(Exercises.fromJson(element));
      }

      return exercises;
    } on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<List<CardioRecords>> getRecords(String exerciseId)async {
    List<CardioRecords> exerciseRecords = [];

    try {
      final records = await FirebaseFirestore.instance
          .collection('cardio')
          .doc(exerciseId)
          .collection('records')
          .where('uId', isEqualTo: CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .get();
      for (var element in records.docs) {
        exerciseRecords.add(CardioRecords.fromJson(element));
      }

      return exerciseRecords;
    } on FirebaseException catch (e) {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> setRecords(SetCardioRecModel? model) async{
    try{
      await FirebaseFirestore.instance
          .collection('cardio')
          .doc(model!.exerciseId)
          .collection('records')
          .add(model.toJson());

      return '';
    }on FirebaseException catch (e) {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }

  }

  @override
  Future<String> deleteRecord(DeleteRecForExercise? deleteRecModel)async
  {
    try{
      await FirebaseFirestore.instance
          .collection(deleteRecModel!.muscleName)
          .doc(deleteRecModel.exerciseId)
          .collection('records')
          .doc(deleteRecModel.recId)
          .delete();

      return '';
    }on FirebaseException catch(e){
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> deleteExercise(Exercises exercise)async =>
      Future(() => '');

}