import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/error_handling/handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../features/exercises/data/data_source/models/pick_precord.dart';
import '../../../../../../features/exercises/data/data_source/models/set_record_model.dart';
import '../../../../../../features/statistics/data/data_source/models/record.dart';
import '../../../../../helpers/global_data_types/delete_record.dart';
import '../../../../../helpers/global_data_types/exercises.dart';
import '../../../../local/cache_helper/shared_prefs.dart';
import '../interface.dart';


class ExercisesImplProxy implements ExercisesInterface{
  ExercisesInterface current;
  ExercisesImplProxy(this.current);
  void switchDataSource(ExercisesInterface newDataSource){
    current = newDataSource;
  }

  @override
  Future<String> deleteExercise(Exercises exercise)async => current.deleteExercise(exercise);

  @override
  Future<String> deleteRecord()async => deleteRecord();

  @override
  Future<List<Exercises>> getExercises(String muscleName)async => current.getExercises(muscleName);

  @override
  Future<List<MyRecord>> getRecords()async => current.getRecords();

  @override
  Future<String> setRecords()async => current.setRecords();
}


class DefaultExercisesImpl implements ExercisesInterface {
  @override
  Future<String> deleteExercise(Exercises exercise)async {return '';}

  @override
  Future<List<Exercises>> getExercises(String muscleName)async{
    try {
      List<Exercises> exercises = [];
      final response = await FirebaseFirestore.instance
          .collection(muscleName)
          .get();

      for (var element in response.docs) {
        exercises.add(Exercises.fromJson(element));
      }

      return exercises;
    } on FirebaseException catch(e) {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  GetRecord? getRecord;
  SetRecModel? model;
  DeleteRecForExercise? deleteRecModel;
  DefaultExercisesImpl({this.getRecord, this.model, this.deleteRecModel});

  // one factory
  @override
  Future<List<MyRecord>> getRecords()async {
    List<MyRecord> records = [];
    try{
      final response = await FirebaseFirestore.instance
          .collection(getRecord!.muscleName)
          .doc(getRecord!.exerciseDoc)
          .collection('records')
          .where(
          'uId',
          isEqualTo: CacheHelper.getInstance().shared.getStringList('userData')?[0]
      ).get();

      for (var element in response.docs) {
        records.add(
          MyRecord.fromJson(element),
        );
      }

      return records;
    } on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> setRecords() async{
    try{
      await FirebaseFirestore.instance
          .collection(model!.muscleName)
          .doc(model!.exerciseId)
          .collection('records')
          .add(model!.toJson());

      return '';
    }on FirebaseException catch(e){
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> deleteRecord()async
  {
    try{
      await FirebaseFirestore.instance
          .collection(deleteRecModel!.muscleName)
          .doc(deleteRecModel?.exerciseId)
          .collection('records')
          .doc(deleteRecModel!.recId)
          .delete();
      return '';
    }on FirebaseException catch(e){
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }
}

class CustomExercisesImpl implements ExercisesInterface {
  @override
  Future<String> deleteExercise(Exercises exercise)async {
    try{
      final userDoc = FirebaseFirestore.instance.collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0]);

      await userDoc
          .collection('customExercises')
          .doc(exercise.id)
          .delete();

      final response = await userDoc.collection('plans').get();
      for (var element in response.docs) {
        List<int> days = [1,2,3,4,5,6];
        for(int i = 0; i < days.length; i++)
        {
          element.reference
              .collection('list$i').doc(exercise.id).delete();
        }
      }

      return '';
    }on FirebaseException catch(e){
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  List<CustomExercises> customExercises = [];

  @override
  Future<List<Exercises>> getExercises(String muscleName)async {
    try{
      customExercises = [];
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('customExercises')
          .where('muscle',isEqualTo: muscleName)
          .get();

      for(var doc in response.docs)
      {
        customExercises.add(
          CustomExercises.fromJson(doc),
        );
      }

      return customExercises;
    } on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }

  }

  GetRecordForCustom? getRecordForCustom;
  SetRecModel? model;
  DeleteRecForCustomExercise? deleteRecModel;
  CustomExercisesImpl({this.getRecordForCustom, this.model, this.deleteRecModel});

  @override
  Future<List<MyRecord>> getRecords()async {
    List<MyRecord> recordsForCustomExercise = [];
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')![0])
          .collection('customExercises')
          .doc(getRecordForCustom!.exerciseDoc)
          .collection('records')
          .get()
          .then((value) {
        for (var element in value.docs) {
          recordsForCustomExercise.add(
              MyRecord.fromJson(element)
          );
        }
      });

      return recordsForCustomExercise;
    } on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> setRecords()async {
    try{
      final userDoc =  FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')![0]);

      userDoc
          .collection('customExercises')
          .doc(model!.exerciseId)
          .collection('records')
          .add(model!.toJson());

      return '';
    } on FirebaseException catch(e){
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> deleteRecord()async {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')![0])
          .collection('customExercises')
          .doc(deleteRecModel!.exerciseId)
          .collection('records')
          .doc(deleteRecModel!.recId)
          .delete();

      return '';
    }on FirebaseException catch(e){
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

}
