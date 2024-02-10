import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  List<MyRecord> records;

  Statistics({super.key,
    required this.records,
  });

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Statistics'),
      ),
      body:
      // state is MakeChartForExerciseLoadingState || state is MakeChartForExerciseInPlanLoadingState?
      // const Center(
      //   child: CircularProgressIndicator(),
      // ):
      SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        title: const ChartTitle(text: 'Analysis'),
        // Enable legend
        legend: const Legend(isVisible: true),
        series: [
          LineSeries(
            dataSource: widget.records,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            xValueMapper: (datum, index) => widget.records[index].weight,
            yValueMapper: (datum, index) => widget.records[index].reps,
          )
        ],
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
}
