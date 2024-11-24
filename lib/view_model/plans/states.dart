class PlansStates {}

class PlansInitialState extends PlansStates {}

class GetAllPlansLoadingState extends PlansStates {}

class GetAllPlansSuccessState extends PlansStates {}

class GetAllPlansErrorState extends PlansStates {}

class DeletePlanState extends PlansStates{}

class DeletePlanErrorState extends PlansStates{}

class DeleteExerciseFromPlanSuccessState extends PlansStates{}

class DeleteExerciseFromPlanErrorState extends PlansStates{}

class MakeChartForExerciseInPlanLoadingState extends PlansStates{}

class MakeChartForExerciseInPlanSuccessState extends PlansStates{}

class MakeChartForExerciseInPlanErrorState extends PlansStates{}

class ChangeDotSuccessState extends PlansStates{}

class AddExerciseToExistingPlan extends PlansStates{}

class AddExerciseToExistingPlanToDatabase extends PlansStates{}