import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/plans/create_plan/ChooseFromExercises.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:flutter/material.dart';

import 'choose_exercises.dart';

class ContinuePlanning extends StatefulWidget {
  String name;
  int? daysNumber;

  ContinuePlanning({super.key,
    required this.name,
    required this.daysNumber,
  });

  @override
  State<ContinuePlanning> createState() => _ContinuePlanningState();
}

class _ContinuePlanningState extends State<ContinuePlanning> {

  @override
  void initState() {
    PlansCubit.getInstance(context).makeListForEachDay(widget.daysNumber);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => Column(
                children: [
                  Card(
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => ChooseFromExercises(
                              //         day: index + 1,
                              //       ),
                              //     ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseExercises(
                                    day: index + 1,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                        )
                      ),
                    ),
                  ),
                ],
              ),
              separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
              itemCount: widget.daysNumber!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400]
              ),
              onPressed: () async {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
                child: MyText(
                  text: 'Create Plan',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
