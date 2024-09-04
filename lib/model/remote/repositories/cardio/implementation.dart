import 'package:be_fit/model/error_handling.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/cardio_records.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../models/data_types/set_cardio_rec_model.dart';

class CardioRepo extends ExercisesMain
{
  late List<Exercises> cardioExercises;

  @override
  Future<Result<List<Exercises>, FirebaseError>> getExercises(BuildContext context, String muscleName)async {
    cardioExercises = [];
    try {
      final result = await FirebaseFirestore.instance
          .collection(muscleName)
          .get();
      for (var element in result.docs) {
        cardioExercises.add(Exercises.fromJson(element));
      }

      return Result.success(cardioExercises);
    } on FirebaseException catch (e) {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  String? exerciseId;
  SetCardioRecModel? model;

  CardioRepo({
    this.exerciseId,
    this.model,
  });

  @override
  Future<Result<dynamic, FirebaseError>> getRecords(BuildContext context) async{
    List<CardioRecords> exerciseRecords = [];

    try {
      final records = await FirebaseFirestore.instance
          .collection('cardio')
          .doc(exerciseId)
          .collection('records')
          .get();
      for (var element in records.docs) {
        exerciseRecords.add(CardioRecords.fromJson(element));
      }

      return Result.success(exerciseRecords);
    } on FirebaseException catch (e) {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  @override
  Future<void> setRecords() async{
    await FirebaseFirestore.instance
        .collection('cardio')
        .doc(model!.exerciseId)
        .collection('records')
        .add(model!.toJson());
  }

  @override
  Future<void> deleteExercise(BuildContext context, {required Exercises exercise, required String muscleName})async {}
}