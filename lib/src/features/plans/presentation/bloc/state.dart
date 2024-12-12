
enum PlansInternalStates {
  plansInitial,
  getPlansLoading,
  getPlansSuccess,
  getPlansError,
  // deletePlanLoading,
  deletePlanSuccess,
  deletePlanError,
  // deleteExerciseFromPlanLoading,
  deleteExerciseFromPlanSuccess,
  deleteExerciseFromPlanError,
  // addExercisesToExistingPlanLoading,
  addExercisesToExistingPlanSuccess,
  addExercisesToExistingPlanError,
}
class PlansState {
  final PlansInternalStates? currentState;
  final Map<String,dynamic>? allPlans;
  final List<String>? allPlansIds;
  final String? errorMsg;

  const PlansState({
    this.currentState,
    this.allPlans,
    this.allPlansIds,
    this.errorMsg
  });

  factory PlansState.initial(){
    return const PlansState(
        currentState : PlansInternalStates.plansInitial,
        allPlans: {},
        allPlansIds: [],
        errorMsg : ''
    );
  }

  PlansState copyWith({
    required PlansInternalStates state,
    Map<String, dynamic>? allPlans,
    List<String>? allPlansIds,
    String? errorMessage
  })
  {
    return PlansState(
      currentState: state,
      allPlans: allPlans?? this.allPlans,
      allPlansIds: allPlansIds?? this.allPlansIds,
      errorMsg: errorMessage?? errorMsg,
    );
  }
  // @override
  // List<Object?> get props => [currentState, allPlans, allPlansIds, errorMsg];
}