import 'dart:developer';

import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideo extends StatefulWidget {

  String exerciseName;
  String url;

  ExerciseVideo({super.key,
    required this.url,
    required this.exerciseName,
  });

  @override
  State<ExerciseVideo> createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  late final VideoPlayerController _controller;

  void init() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.url
      ),
    )..initialize().then((value) {
        setState(() {});
      }).catchError((error) {
        log(error.toString());
      });
    log('$_controller');
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: widget.exerciseName),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const Center(child: CircularProgressIndicator(),)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
