import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/log/chart_screen.dart';
import 'package:be_fit/view_model/log/cubit.dart';
import 'package:be_fit/view_model/log/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Log extends StatefulWidget {

  String exerciseId;
  String muscleName;

   Log({super.key,
    required this.exerciseId,
     required this.muscleName,
  });

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {

  @override
  void initState() {
    LogCubit.getInstance(context).sendRecordsToMakeChartForSpeExer(
        exerciseId: widget.exerciseId,
    );
    LogCubit.getInstance(context).sendRecordsToMakeChart(
        muscleName: widget.muscleName,
        exerciseId: widget.exerciseId,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogCubit,LogStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Statistics'),
          ),
          body: ChartScreen(
            reps: LogCubit.getInstance(context).recordsRepsForExercise,
          ),
        );
      },
    );
  }
}
