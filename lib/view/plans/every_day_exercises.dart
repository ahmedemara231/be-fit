import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';
import '../../models/exercises.dart';
import '../../view_model/plans/cubit.dart';
import 'exercise_details.dart';

class DayExercises extends StatelessWidget {
  int dayIndex;
  String planDoc;
  int listIndex;
  List<Exercises> dayExercises = [];

  DayExercises({super.key,
    required this.dayExercises,
    required this.dayIndex,
    required this.planDoc,
    required this.listIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Day$dayIndex exercises'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => InkWell(
            onLongPress: ()
            {
              showMenu(
                context: context,
                position: RelativeRect.fromDirectional(
                  textDirection: TextDirection.ltr,
                  start: 50,
                  top: 20,
                  end: 50,
                  bottom: 20,
                ),
                items: [
                  PopupMenuItem(
                    child: MyText(text: 'Delete'),
                    onTap: () async
                    {
                      await PlansCubit.getInstance(context).deleteExerciseFromPlan(
                        planDoc: planDoc,
                        listIndex: listIndex,
                        exerciseDoc:dayExercises[index].id,
                      );
                    },
                  )
                ],
              );
            },
            onTap: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanExerciseDetails(
                      planDoc: planDoc,
                      listIndex: listIndex,
                      exercise: dayExercises[index],
                    ),
                  ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Image.network(dayExercises[index].image),
                title: MyText(text: dayExercises[index].name,fontSize: 18,fontWeight: FontWeight.w500,),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16,),
          itemCount: dayExercises.length,
      ),
    );
  }
}
