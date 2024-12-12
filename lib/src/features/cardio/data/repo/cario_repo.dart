import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/extensions/future.dart';
import 'package:be_fit/src/core/helpers/global_data_types/exercises.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/helpers/global_data_types/delete_record.dart';
import '../data_source/cardio_data_source.dart';
import '../data_source/models/cardio_records.dart';
import '../data_source/models/set_cardio_rec_model.dart';

class CardioRepo{
  CardioDataSource dataSource;
  CardioRepo(this.dataSource);

  Future<Result<List<Exercises>, FirebaseError>> getCardioExercises()async{
    return dataSource
        .getCardioExercises()
        .handleFirebaseCalls();
  }

  Future<Result<String, FirebaseError>> setRec(SetCardioRecModel? model) async{
    return dataSource
        .setRecord(model)
        .handleFirebaseCalls();
  }

  Future<Result<List<CardioRecords>, FirebaseError>> getRecords(String exerciseId) async{
    return dataSource
        .getRecord(exerciseId)
        .handleFirebaseCalls();
  }

  Future<Result<String, FirebaseError>> deleteRec(DeleteRecForExercise deleteRecModel) async{
    return dataSource
        .deleteRecord(deleteRecModel)
        .handleFirebaseCalls();
  }
}