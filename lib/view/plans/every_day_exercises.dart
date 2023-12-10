import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';
import '../../models/exercises.dart';
import 'exercise_details.dart';

class DayExercises extends StatelessWidget {
  int dayIndex;
  List<Exercises> dayExercises = [];
  DayExercises({super.key,
    required this.dayExercises,
    required this.dayIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Day$dayIndex exercises'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => InkWell(
            onTap: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanExerciseDetails(
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
