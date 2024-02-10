import '../../models/data_types/exercises.dart';

class PlanCreationStates{}

class PlanCreationInitialState extends PlanCreationStates{}

class GetAllMusclesLoadingState extends PlanCreationStates {}

class GetAllMusclesSuccessState extends PlanCreationStates {}

class GetAllMusclesErrorState extends PlanCreationStates {}

class AddCustomExerciseToMuscles extends PlanCreationStates{}

class RemoveCustomExerciseFromMuscles extends PlanCreationStates{}

class ChangeCheckBoxValue extends PlanCreationStates {}

class AddToExercisePlanList extends PlanCreationStates {}

class RemoveFromExercisePlanList extends PlanCreationStates {}

class RemoveFromDismissList extends PlanCreationStates {}

class PutExercisesInList extends PlanCreationStates{}

class ChangeDaysNumber extends PlanCreationStates{}

class CreateNewPlanLoadingState extends PlanCreationStates{}

class CreateNewPlanSuccessState extends PlanCreationStates{}

class CreateNewPlanErrorState extends PlanCreationStates{}
