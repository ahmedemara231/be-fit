import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';
import 'package:be_fit/src/features/statistics/data/data_source/models/record.dart';

class StatisticsDataSource{
  ExercisesInterface interface;
  StatisticsDataSource(this.interface);

  Future<List<MyRecord>> getRecords()async{
    return await interface.getRecords();
  }
}