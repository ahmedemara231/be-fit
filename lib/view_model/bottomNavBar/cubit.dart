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
    required PlanCreationCubit planCreationCubit,
    required PlansCubit plansCubit,
    required uId,
})async
  {
    currentIndex = newIndex;
    emit(BottomNavState());
    if(newIndex == 1)
      {
        if(plansCubit.allPlans.isNotEmpty || planCreationCubit.musclesAndItsExercises.isNotEmpty)
        {
          return;
        }
        else{
          await plansCubit.getAllPlans(context, uId);
          await planCreationCubit.getMuscles(context, uId: uId);
        }
      }
    else{
      return;
    }
  }

  void returnToFirst()
  {
    currentIndex = 0;
    emit(BottomNavState());
  }
}


