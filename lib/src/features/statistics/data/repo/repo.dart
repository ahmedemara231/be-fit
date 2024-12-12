import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/extensions/future.dart';
import 'package:be_fit/src/features/statistics/data/data_source/data_source.dart';
import 'package:multiple_result/multiple_result.dart';

import '../data_source/models/record.dart';


class StatisticsRepo{
  StatisticsDataSource interface;
  StatisticsRepo(this.interface);

  Future<Result<List<MyRecord>, FirebaseError>> getRecords()async{
    return await interface
        .getRecords()
        .handleFirebaseCalls();
  }
}