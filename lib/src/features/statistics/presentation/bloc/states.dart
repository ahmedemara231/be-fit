import 'package:equatable/equatable.dart';

import '../../data/data_source/models/record.dart';

enum StatisticsInternalState {
  initialState,
  getRecordsLoading,
  getRecordsSuccess,
  getRecordsError,
}
class StatisticsState extends Equatable {
  final StatisticsInternalState? currentState;
  final List<MyRecord>? records;

  const StatisticsState({
    this.currentState,
    this.records,
  });

  factory StatisticsState.initial(){
    return const StatisticsState(
      currentState : StatisticsInternalState.initialState,
      records: [],
    );
  }

  StatisticsState copyWith({
    required StatisticsInternalState state,
    List<MyRecord>? records,
  }) {
    return StatisticsState(
      currentState: state,
      records: records?? this.records,
    );
  }

  @override
  List<Object?> get props => [
    currentState,
  ];
}