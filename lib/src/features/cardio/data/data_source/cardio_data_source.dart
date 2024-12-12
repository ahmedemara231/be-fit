import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../../core/helpers/global_data_types/delete_record.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import 'models/cardio_records.dart';
import 'models/set_cardio_rec_model.dart';

class CardioDataSource{
  CardioExercisesInterface interface;
  CardioDataSource(this.interface);
  Future<List<Exercises>> getCardioExercises()async{
    return await interface.getExercises();
  }
  Future<String> setRecord(SetCardioRecModel? model)async{
    return interface.setRecords(model);
  }
  Future<List<CardioRecords>> getRecord(String exerciseId)async{
    return interface.getRecords(exerciseId);
  }
  Future<String> deleteRecord(DeleteRecForExercise? deleteRecModel)async{
    return interface.deleteRecord(deleteRecModel);
  }
  }
