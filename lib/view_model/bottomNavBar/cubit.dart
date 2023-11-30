import 'package:be_fit/view_model/bottomNavBar/states.dart';
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
}