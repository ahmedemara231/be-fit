import 'package:be_fit/view_model/plans/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit(super.initialState);
  static PlansCubit getInstance(context) => BlocProvider.of(context);

  Future<void> createNewPlan({
    required String workoutName,
    required String numberOfDays,
    required String uId,
})async
  {
    int? daysNumber = int.tryParse(numberOfDays);
    await FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('plans')
        .add(
        {
          'workoutName' : workoutName,
          'numberOfDays' : daysNumber,
        }
    ).then((value)
    {
      print('added');
    });

  }

  List<Map<String,dynamic>> plans = [];
  Future<void> getAllPlans()async
  {
    plans = [];
    emit(GetAllPlansLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('plans')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        plans.add(element.data());
      });
      print(plans);
      emit(GetAllPlansSuccessState());
    }).catchError((error)
    {
      emit(GetAllPlansErrorState());
    });
  }
}