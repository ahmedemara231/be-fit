import 'dart:async';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<BottomNavState>
{
  BottomNavCubit(super.initialState);
  static BottomNavCubit getInstance(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Future<void> changeScreen(context,{
    required int newIndex,
    required uId,
})async
  {
    currentIndex = newIndex;
    emit(BottomNavState());
    if(newIndex == 1)
      {
        if(PlansCubit.getInstance(context).allPlans.isEmpty ||
            PlanCreationCubit.getInstance(context).musclesAndItsExercises.isEmpty)
        {
          await PlansCubit.getInstance(context).getAllPlans(context, uId);
          await PlanCreationCubit.getInstance(context).getMuscles(context, uId: uId);
        }
      }
  }

  void returnToFirst()
  {
    currentIndex = 0;
    emit(BottomNavState());
  }
}


