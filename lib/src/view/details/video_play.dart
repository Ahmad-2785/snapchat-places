import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final String? pathh;

  const VideoPlay({
    super.key,
    required this.pathh, // Video from assets folder
  });

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.pathh!),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    futureController = controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Stack(children: [
            Positioned.fill(child: VideoPlayer(controller!)),
          ]);
        }
      },
    );
  }
}
