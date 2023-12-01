import 'package:be_fit/view_model/log/cubit.dart';
import 'package:be_fit/view_model/log/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'line_chart.dart';

class ChartScreen extends StatefulWidget {

  List<double> reps;

  ChartScreen({super.key,
    required this.reps,
  });

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    print(widget.reps);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogCubit,LogStates>(
      builder: (context, state)
      {
        return Scaffold(
          backgroundColor: Colors.black12,
          body:
          SingleChildScrollView(
            child:
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: LineChartWidget(
                reps: widget.reps,
              ),
            ),
          ),
        );
      },
    );
  }
}
