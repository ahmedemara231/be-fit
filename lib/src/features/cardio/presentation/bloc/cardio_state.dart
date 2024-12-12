part of 'cardio_cubit.dart';
class CardioStates {}

final class CardioInitial extends CardioStates {}

class GetCardioExercisesLoading extends CardioStates {}

class GetCardioExercisesSuccess extends CardioStates {
  List<Exercises> cardioExercises;
  List<Exercises> cardioExercisesList;
  GetCardioExercisesSuccess({required this.cardioExercises, required this.cardioExercisesList});
}

class NewSearchState extends CardioStates{}

class GetCardioExercisesError extends CardioStates {
  String error;
  GetCardioExercisesError({required this.error});
}

class SetCardioRecLoading extends CardioStates {}

class SetCardioRecSuccess extends CardioStates {}

class SetCardioRecError extends CardioStates {
  String error;
  SetCardioRecError({required this.error});
}

class GetCardioRecordsLoading extends CardioStates {}

class GetCardioRecordsSuccess extends CardioStates {
  List<CardioRecords> records;
  GetCardioRecordsSuccess(this.records);
}

class GetCardioRecordsError extends CardioStates {
  String error;
  GetCardioRecordsError({required this.error});
}

class DeleteCardioRecLoading extends CardioStates {}

class DeleteCardioRecSuccess extends CardioStates {}

class DeleteCardioRecError extends CardioStates {
  String error;
  DeleteCardioRecError({required this.error});
}

