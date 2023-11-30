import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class RecordsModel extends StatelessWidget {
  const RecordsModel({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        MyText(
          text: 'TIME',
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        const Spacer(),
        MyText(
          text: 'WEIGHT(KG)',
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        const Spacer(),
        MyText(
          text: 'REPS',
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        const Spacer(),
      ],
    );
  }
}
