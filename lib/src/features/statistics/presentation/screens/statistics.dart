import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../data/data_source/factory_method.dart';
import '../bloc/cubit.dart';
import '../bloc/states.dart';

class Statistics extends StatefulWidget {
  final Exercises exercise;

  const Statistics({super.key,
    required this.exercise,
  });

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  late ExercisesInterface exerciseType;

  @override
  void initState() {
    exerciseType = GetRecordsExecuter.factory(widget.exercise);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Statistics'),
      ),
      body: BlocProvider<StatisticsCubit>(
        create: (context) => GetIt.instance.get<StatisticsCubit>()..pickRecordsToMakeChart(
            exerciseType
        ),
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) => SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: ChartTitle(text: '${widget.exercise.name} Analysis'),
            legend: const Legend(isVisible: true),
            series: [
              // if(exerciseType is CardioImpl)
              //   LineSeries(
              //     dataSource: StatisticsCubit.getInstance(context).cardioRecords,
              //     dataLabelSettings: const DataLabelSettings(isVisible: true),
              //     xValueMapper: (datum, index) => StatisticsCubit.getInstance(context).cardioRecords[index].time,
              //     yValueMapper: (datum, index) => index + 1,
              //   ) else
                  LineSeries(
                    dataSource: state.records,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    xValueMapper: (datum, index) => state.records?[index].reps,
                    yValueMapper: (datum, index) => state.records?[index].weight,
                  )
            ],
          ),
        ),
      ),
    );
  }
}

