import 'package:be_fit/models/exercises.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

import '../../modules/otp_tff.dart';

class PlanExerciseDetails extends StatelessWidget {
  late Exercises exercise;
  PlanExerciseDetails({super.key,
    required this.exercise,
  });

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final weightCont = TextEditingController();
  final repsCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText(text: exercise.name),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                exercise.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: ()
                {
                  scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyText(
                        text: exercise.docs,
                        maxLines: 20,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ));
                },
                icon: const Icon(Icons.question_mark),
              ),
              const Spacer(),
              IconButton(
                onPressed: ()
                {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ExerciseVideo(
                  //         video: videoUrl,
                  //       ),
                  //     ),
                  // );
                },
                icon: const Icon(Icons.play_arrow),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month,color: Colors.white,size: 55,),
                          MyText(text: 'TODAY',color: Colors.white,fontSize: 25,),
                        ],
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/5,
                            child: OtpTff(
                              controller: weightCont,
                              hintText: 'weight',
                            ),
                          ),
                          const Spacer(flex: 4,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/5,
                            child: OtpTff(
                              controller: repsCont,
                              hintText: 'reps',
                            ),
                          ),
                          const Spacer(flex: 4,),
                          InkWell(
                            onTap: () async{},
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Icon(Icons.add,size: 30,)
                                )),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
