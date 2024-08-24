import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/local/cache_helper/shared_prefs.dart';
import 'package:be_fit/view/exercises/exercises.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/myText.dart';


class BodyMuscles extends StatefulWidget {
  const BodyMuscles({super.key});

  @override
  State<BodyMuscles> createState() => _BodyMusclesState();
}

class _BodyMusclesState extends State<BodyMuscles> {

  late TextEditingController searchCont;
  @override
  void initState() {
    searchCont  = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    searchCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    text: 'Hello, ${CacheHelper.getInstance().getData('userData')[1]}',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        MyText(
                          text: 'Select',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(width: 10,),
                        MyText(
                          text: 'Muscle',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Constants.appColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                        onTap: ()
                        {
                          context.normalNewRoute(
                            ExercisesForMuscle(
                              muscleName: ExercisesCubit.getInstance(context).musclesList[index].text,
                              numberOfExercises: ExercisesCubit.getInstance(context).musclesList[index].numberOfExercises,
                            ),
                          );
                        },
                        child: ExercisesCubit.getInstance(context).musclesList[index],
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemCount: ExercisesCubit.getInstance(context).musclesList.length
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}