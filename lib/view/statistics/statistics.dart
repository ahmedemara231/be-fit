import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/view/statistics/factory_method.dart';
import 'package:be_fit/view_model/statistics/cubit.dart';
import 'package:be_fit/view_model/statistics/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/remote/firebase_service/fire_store/cardio/implementation.dart';
import '../../model/remote/firebase_service/fire_store/interface.dart';

class Statistics extends StatefulWidget {
  final Exercises exercise;

  const Statistics({super.key,
    required this.exercise,
  });

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  late ExercisesMain exerciseType;

  @override
  void initState() {
    exerciseType = GetRecordsExecuter().factory(widget.exercise);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Statistics'),
      ),
      body:
      BlocProvider<StatisticsCubit>(
        create: (context) => StatisticsCubit()..pickRecordsToMakeChart(
            context,
            exerciseType: exerciseType
        ),
        child: BlocBuilder<StatisticsCubit, StatisticsStates>(
          builder: (context, state) => SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: ChartTitle(text: '${widget.exercise.name} Analysis'),
            legend: const Legend(isVisible: true),
            series: [
              if(exerciseType is CardioRepo)
                LineSeries(
                  dataSource: StatisticsCubit.getInstance(context).cardioRecords,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  xValueMapper: (datum, index) => StatisticsCubit.getInstance(context).cardioRecords[index].time,
                  yValueMapper: (datum, index) => index + 1,
                ) else
                  LineSeries(
                    dataSource: StatisticsCubit.getInstance(context).records,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    xValueMapper: (datum, index) => StatisticsCubit.getInstance(context).records[index].reps,
                    yValueMapper: (datum, index) => StatisticsCubit.getInstance(context).records[index].weight,
                  )
            ],
          ),
        ),
      ),
    );
  }
}

class MyRecord {
  var reps;
  var weight;

  MyRecord({
  required this.reps,
  required this.weight,
  });

  factory MyRecord.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> jsonRecord)
  {
    return MyRecord(
        reps: jsonRecord.data()['reps'],
        weight: jsonRecord.data()['weight']
    );
  }
}
