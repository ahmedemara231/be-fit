import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatelessWidget {
  List<MyRecord> records;

  Statistics({super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder:(context, state) => BlocBuilder<PlansCubit,PlansStates>(
        builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Statistics'),
          ),
          body: state is MakeChartForExerciseLoadingState || state is MakeChartForExerciseInPlanLoadingState?
          const Center(
            child: CircularProgressIndicator(),
          ):
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: const ChartTitle(text: 'Analysis'),
            // Enable legend
            legend: const Legend(isVisible: true),
            series: [
              LineSeries(
                dataSource: records,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                xValueMapper: (datum, index) => records[index].weight,
                yValueMapper: (datum, index) => records[index].reps,
              )
            ],
          ),
        );
      },),
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
}
