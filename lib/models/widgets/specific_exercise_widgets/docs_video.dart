import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../modules/myText.dart';

class DocsAndVideo extends StatelessWidget {
  final Exercises exercise;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DocsAndVideo({
    super.key,
    required this.exercise,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            final List<String> docs = exercise.docs.split('.');
            scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Padding(
                    padding:  EdgeInsets.all(16.0.r),
                    child: ListView(
                      children: [
                        MyText(
                          text:
                              'Note : It\'s really important to match these steps if you don\'t know how to perform this exercises',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          maxLines: 5,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              docs.length,
                              (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13.0),
                                  child: MyText(
                                    text:
                                        '${index + 1} : ${docs[index].isNotEmpty ? docs[index] : 'Exercise Hard'}',
                                    maxLines: 20,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ))),
                        )
                      ],
                    ),
                  ),
                ));
          },
          icon: const Icon(Icons.question_mark),
        ),
        const Spacer(),
        if (exercise.isCustom == false)
          IconButton(
            onPressed: () {
              context.normalNewRoute(PlayVideo(
                  url: exercise.video.isEmpty
                      ? 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
                      : exercise.video,
                  exerciseName: exercise.name));
            },
            icon: const Icon(Icons.play_arrow),
          )
      ],
    );
  }
}
