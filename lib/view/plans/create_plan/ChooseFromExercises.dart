import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class ChooseFromExercises extends StatelessWidget {
  ChooseFromExercises({super.key});

  List<String> muscles =
  [
    'chest',
    'Back',
    'Shoulders',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'text'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => Card(
          color: Colors.red[400],
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: MyText(text: muscles[index]),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  )
              )
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        itemCount: muscles.length,
      ),
    );
  }
}
