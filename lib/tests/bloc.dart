import 'package:flutter_bloc/flutter_bloc.dart';

class TestBloc extends Cubit<TestStates> {

  TestBloc() : super(Initial());
  factory TestBloc.getInstance(context) => BlocProvider.of(context);

  int counter = 0;
  void inc(){
    counter++;
    emit(CounterInc());
  }
}

class TestStates {}
class Initial extends TestStates {}
class CounterInc extends TestStates {}