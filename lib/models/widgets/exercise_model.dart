import 'package:be_fit/constants.dart';
import 'package:flutter/material.dart';

import 'modules/myText.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Constants.appColor),
            right: BorderSide(color: Constants.appColor),
            bottom: BorderSide(color: Constants.appColor),
            left: BorderSide(color: Constants.appColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: Image.asset('images/$imageUrl.png'),
            title: MyText(
              text: text,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            subtitle: MyText(
              text: '$numberOfExercises Exercises',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
