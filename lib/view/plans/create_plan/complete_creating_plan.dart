import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

import '../ChooseFromExercises.dart';

class ContinuePlanning extends StatelessWidget {
  String name;
  int? daysNumber;

  ContinuePlanning({super.key,
    required this.name,
    required this.daysNumber,
  });

  List<String> muscles =
  [
    'chest',
    'Back',
    'Shoulders',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: DropdownButton(
      //
      //   items: [
      //     DropdownMenuItem(child: MyText(text: 'ahmed'),value: 1),
      //     DropdownMenuItem(child: MyText(text: 'ahmed'),value: 1),
      //     DropdownMenuItem(child: MyText(text: 'ahmed'),value: 1),
      //     DropdownMenuItem(child: MyText(text: 'ahmed'),value: 1),
      //   ],
      //   onChanged: (value) {},
      // ),

      // body: CheckboxListTile(
      //   title: MyText(text: 'ahmed'),
      //   subtitle: MyText(text: 'ahmed2'),
      //   value: true,
      //   onChanged: (value) {},
      // ),

      body: ListView.separated(
        itemBuilder: (context, index) => Card(
          color: Colors.red[400],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: MyText(
                text: 'Day ${index + 1}',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              trailing: IconButton(
                  onPressed: ()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseFromExercises(),
                        ),
                    );
                  },
                  icon: const Icon(Icons.add),
              )
            )
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        itemCount: daysNumber!,
      ),
    );
  }
}
