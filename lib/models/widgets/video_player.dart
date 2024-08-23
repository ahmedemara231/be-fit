import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'modules/myText.dart';

class PlayVideo extends StatefulWidget {

  final String url;
  final String exerciseName;

  const PlayVideo({super.key,
    required this.url,
    required this.exerciseName
  });

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  void initControllers()
  {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url)
    );
    videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
    );
  }

  @override
  void initState() {
    initControllers();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: widget.exerciseName),
      ),
      body: Chewie(controller: chewieController),
    );
  }
}
