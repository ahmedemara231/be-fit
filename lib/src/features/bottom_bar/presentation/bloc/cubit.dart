import 'dart:async';
import 'package:be_fit/src/features/bottom_bar/presentation/bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<BottomNavState>
{
  BottomNavCubit() : super(BottomNavState());
  factory BottomNavCubit.getInstance(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Future<void> changeScreen(context,{
    required int newIndex
})async
  {
    currentIndex = newIndex;
    emit(BottomNavState());
  }

  void returnToFirst()
  {
    currentIndex = 0;
    emit(BottomNavState());
  }
}


