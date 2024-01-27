import 'dart:async';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/internet_connection_check/internet_connection_check.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<BottomNavState>
{
  BottomNavCubit(super.initialState);
  static BottomNavCubit getInstance(context) => BlocProvider.of(context);

  int currentIndex = 0;
  void changeScreen({
    required int newIndex,
})
  {
    currentIndex = newIndex;
    emit(BottomNavState());
  }
////////////////////////////////////////

  Future<void> getAllPlans({
    required String uId,
    required context,
    required InternetCheck checkMethod
})async
  {
    InternetCheck internetCheck = checkMethod;
    internetCheck.internetCheck(
      context,
      validConnectionAction: () async
      {
        emit(FetchAllDataLoadingState());
        PlansCubit.getInstance(context).test();
        await PlansCubit.getInstance(context).getAllPlans(uId);
        await PlansCubit.getInstance(context).getMuscles(uId: CacheHelper.getInstance().uId);
        emit(FetchAllDataSuccessState());
      },
    );
  }
}


