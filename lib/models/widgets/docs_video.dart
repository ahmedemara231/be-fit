import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:flutter/material.dart';
import 'modules/myText.dart';
import '../../view/exercises/exercise_video.dart';

class DocsAndVideo extends StatelessWidget {

  final Exercises exercise;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DocsAndVideo({super.key,
    required this.exercise,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: ()
          {
            scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/1.2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    MyText(
                      text: 'Note : It\'s really important to match these steps if you don\'t know how to perform this exercises',
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyText(
                      text: exercise.docs,
                      maxLines: 20,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ));
          },
          icon: const Icon(Icons.question_mark),
        ),
        const Spacer(),
        if(exercise.isCustom == false)
          IconButton(
            onPressed: ()
            {
              context.normalNewRoute(
                ExerciseVideo(
                  exerciseName: exercise.name,
                  url: exercise.video.isEmpty?
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4' :
                  exercise.video,
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
          )
      ],
    );
  }
}
