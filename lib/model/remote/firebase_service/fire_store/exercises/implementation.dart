import 'package:be_fit/model/local/cache_helper/shared_prefs.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/src/result.dart';
import '../../../../../models/data_types/delete_record.dart';
import '../../../../../models/data_types/pick_precord.dart';
import '../../../../../models/data_types/setRecord_model.dart';
import '../../../../../view/statistics/statistics.dart';
import '../../error_handling.dart';
import '../interface.dart';

class DefaultExercisesImpl extends ExercisesMain
{
  @override
  Future<void> deleteExercise(BuildContext context,{
  required Exercises exercise,
  required String muscleName
  })async {}

  @override
  Future<Result<List<Exercises>, FirebaseError>> getExercises(BuildContext context, String muscleName)async {
    try {
      List<Exercises> exercises = [];
      await FirebaseFirestore.instance
          .collection(muscleName)
          .get()
          .then((value)
      {
        for (var element in value.docs) {
          exercises.add(Exercises.fromJson(element));
        }
      });

      return Result.success(exercises);

    } on FirebaseException catch(e)
    {
      FirebaseError newFirebaseError = ErrorHandler().handleFireStoreError(context, e);
      return Result.error(newFirebaseError);
    }
  }

  GetRecord? getRecord;
  SetRecModel? model;
  DeleteRecForExercise? deleteRecModel;
  DefaultExercisesImpl({this.getRecord, this.model, this.deleteRecModel});

  // one factory
  @override
  Future<Result<List<MyRecord>, FirebaseError>> getRecords(BuildContext context)async {
    List<MyRecord> records = [];
    try{
      await FirebaseFirestore.instance
          .collection(getRecord!.muscleName)
          .doc(getRecord!.exerciseDoc)
          .collection('records')
          .where(
          'uId',
          isEqualTo: CacheHelper.getInstance().shared.getStringList('userData')?[0]
      ).get().then((value)
      {
        for (var element in value.docs) {
          records.add(
            MyRecord.fromJson(element),
          );
        }
      });

      return Result.success(records);
    } on FirebaseException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  // no one factory
  @override
  Future<void> setRecords() async{
    await FirebaseFirestore.instance
        .collection(model!.muscleName)
        .doc(model!.exerciseId)
        .collection('records')
        .add(model!.toJson());
  }

  // one factory
  @override
  Future<void> deleteRecord()async
  {
    await FirebaseFirestore.instance
        .collection(deleteRecModel!.muscleName)
        .doc(deleteRecModel?.exerciseId)
        .collection('records')
        .doc(deleteRecModel!.recId)
        .delete();
  }
}

class CustomExercisesImpl extends ExercisesMain
{
  @override
  Future<void> deleteExercise(BuildContext context,{
    required Exercises exercise,
    required String muscleName
  })async {
    final userDoc = FirebaseFirestore.instance.collection('users')
        .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0]);

    await userDoc
        .collection('customExercises')
        .doc(exercise.id)
        .delete()
        .then((value) {

      userDoc.collection('plans').get().then((value) {
        for (var element in value.docs) {
          List<int> days = [1,2,3,4,5,6];
          for(int i = 0; i < days.length; i++)
            {
              element.reference
                  .collection('list$i').doc(exercise.id).delete();
            }
        }
      });
    });
  }

  List<CustomExercises> customExercises = [];

  @override
  Future<Result<List<Exercises>, FirebaseError>> getExercises(BuildContext context, String muscleName)async {
    try{
      customExercises = [];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('customExercises')
          .where('muscle',isEqualTo: muscleName)
          .get().then((value) {
        for(var doc in value.docs)
        {
          customExercises.add(
            CustomExercises.fromJson(doc),
          );
        }
      });

      return Result.success(customExercises);
    } on FirebaseException catch(e)
    {
      FirebaseError error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }

  }

  GetRecordForCustom? getRecordForCustom;
  SetRecModel? model;
  DeleteRecForCustomExercise? deleteRecModel;
  CustomExercisesImpl({this.getRecordForCustom, this.model, this.deleteRecModel});

  @override
  Future<Result<List<MyRecord>, FirebaseError>> getRecords(BuildContext context)async {
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

      return Result.success(recordsForCustomExercise);
    } on FirebaseException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  @override
  Future<void> setRecords()async {
    final userDoc =  FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getInstance().shared.getStringList('userData')![0]);

    userDoc
        .collection('customExercises')
        .doc(model!.exerciseId)
        .collection('records')
        .add(model!.toJson());
  }

  @override
  Future<void> deleteRecord()async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getInstance().shared.getStringList('userData')![0])
        .collection('customExercises')
        .doc(deleteRecModel!.exerciseId)
        .collection('records')
        .doc(deleteRecModel!.recId)
        .delete();
  }

}
