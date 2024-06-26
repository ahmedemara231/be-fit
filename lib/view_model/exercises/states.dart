import 'package:be_fit/models/data_types/exercises.dart';

class ExercisesStates {}

class ChangeBody extends ExercisesStates{}

class ExerInitialState extends ExercisesStates {}

class NewMuscleSearchState extends ExercisesStates{}

class NewExerciseSearchState extends ExercisesStates{}

class NewSearchState extends ExercisesStates{}

class GetExercisesLoadingState extends ExercisesStates {}

class GetExercisesSuccessState extends ExercisesStates {}

class GetExercisesErrorState extends ExercisesStates {}

class MakeChartForExerciseLoadingState extends ExercisesStates{}

class MakeChartForExerciseSuccessState extends ExercisesStates{}

class SetNewRecordLoadingState extends ExercisesStates {}

class SetNewRecordSuccessState extends ExercisesStates {}

class SetNewRecordErrorState extends ExercisesStates {}

class GetRecordsLoadingState extends ExercisesStates {}

class GetRecordsSuccessState extends ExercisesStates {}

class GetRecordsErrorState extends ExercisesStates {}

class CreateCustomExerciseLoadingState extends ExercisesStates {}

class CreateCustomExerciseSuccessState extends ExercisesStates {}

class CreateCustomExerciseErrorState extends ExercisesStates {}

class PickCustomExerciseImageSuccessState extends ExercisesStates {}

class PickCustomExerciseImageErrorState extends ExercisesStates {}

class GetCustomExercisesLoadingState extends ExercisesStates {}

class GetCustomExercisesSuccessState extends ExercisesStates {}

class GetCustomExercisesErrorState extends ExercisesStates {}

class SetRecordForCustomExerciseLoadingState extends ExercisesStates {}

class SetRecordForCustomExerciseSuccessState extends ExercisesStates {}

class SetRecordForCustomExerciseErrorState extends ExercisesStates {}

class DeleteCustomExerciseSuccessState extends ExercisesStates{}

class DeleteCustomExerciseErrorState extends ExercisesStates{}

class ChangeDotSuccessState extends ExercisesStates {}

class RemoveSelectedImage extends ExercisesStates{}