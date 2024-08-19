import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/pick_precord.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  Exercises exercise;

  Statistics({super.key,
    required this.exercise,
  });

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  late MainFunctions exerciseType;
  @override
  void initState() {
    if(widget.exercise.isCustom)
      {
        exerciseType = CustomExercisesImpl(
          getRecordForCustom: GetRecordForCustom(
            exerciseDoc: widget.exercise.id,
          )
        );
      }
    else{
      exerciseType = DefaultExercisesImpl(
        getRecord: GetRecord(
            muscleName: widget.exercise.muscleName!,
            exerciseDoc: widget.exercise.id,
        ),
      );
    }
    ExercisesCubit.getInstance(context).pickRecordsToMakeChart(
        context,
        exerciseType: exerciseType
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Statistics'),
      ),
      body:
      BlocBuilder<ExercisesCubit, ExercisesStates>(
        builder: (context, state) => SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(text: 'Analysis'),
          // Enable legend
          legend: const Legend(isVisible: true),
          series: [
            if(state is MakeChartForExerciseLoadingState)
              LineSeries(
                dataSource: ExercisesCubit.getInstance(context).records,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                xValueMapper: (datum, index) => 0,
                yValueMapper: (datum, index) => 50,
              ) else
                LineSeries(
              dataSource: ExercisesCubit.getInstance(context).records,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (datum, index) => ExercisesCubit.getInstance(context).records[index].weight,
              yValueMapper: (datum, index) => ExercisesCubit.getInstance(context).records[index].reps,
            )
          ],
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
