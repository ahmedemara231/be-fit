import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class ExerciseModel extends StatelessWidget {

  String imageUrl;
  String text;
  int numberOfExercises;
   ExerciseModel({super.key,
     required this.imageUrl,
     required this.text,
     required this.numberOfExercises,
   });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('images/$imageUrl.jpeg'),
      title: MyText(
        text: text,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      subtitle: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyText(
              text: '$numberOfExercises Exercises',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
