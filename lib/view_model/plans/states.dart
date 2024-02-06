import 'package:be_fit/view_model/plans/cubit.dart';

class PlansStates {}

class PlansInitialState extends PlansStates {}

class GetAllPlansLoadingState extends PlansStates {}

class GetAllPlansSuccessState extends PlansStates {}

class GetAllPlansErrorState extends PlansStates {}

class GetAllPlans2LoadingState extends PlansStates {}

class GetAllPlans2SuccessState extends PlansStates {}

class GetAllPlans2ErrorState extends PlansStates {}

class DeletePlanSuccessState extends PlansStates{}

class DeletePlanErrorState extends PlansStates{}

class DeleteExerciseFromPlanSuccessState extends PlansStates{}

class DeleteExerciseFromPlanErrorState extends PlansStates{}

class MakeChartForExerciseInPlanLoadingState extends PlansStates{}

class MakeChartForExerciseInPlanSuccessState extends PlansStates{}


