import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideo extends StatefulWidget {

  String video;
   ExerciseVideo({super.key,
     required this.video,
   });

  @override
  State<ExerciseVideo> createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    print('video :: ${widget.video}');
    // _controller = VideoPlayerController.networkUrl(Uri(path: widget.video,))
    //   ..initialize();
    _controller = VideoPlayerController.asset('videos/untitled12 – main.dart [untitled12] 2023-11-19 01-12-31.mp4')
      ..initialize();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller.value.isInitialized ?
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ) : const Center(
            child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
