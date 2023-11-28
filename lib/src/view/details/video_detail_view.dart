import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoDetailView extends StatefulWidget {
  const VideoDetailView({super.key});

  @override
  State<VideoDetailView> createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends State<VideoDetailView> {
  final Map<String, dynamic> arguments = Get.arguments;
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(arguments['path']),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    futureController = controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller!.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureController,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stack(children: [
              Positioned.fill(child: VideoPlayer(controller!)),
              Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                    valueListenable: currentPosition,
                    builder: (context, VideoPlayerValue? videoPlayerValue, w) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              videoPlayerValue!.position.toString().substring(
                                  videoPlayerValue.position
                                          .toString()
                                          .indexOf(':') +
                                      1,
                                  videoPlayerValue.position
                                      .toString()
                                      .indexOf('.')),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                controller!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (controller!.value.isPlaying) {
                                    controller!.pause();
                                  } else {
                                    controller!.play();
                                  }
                                });
                              },
                            ),
                            const Spacer(),
                            Text(
                              videoPlayerValue.duration.toString().substring(
                                  videoPlayerValue.duration
                                          .toString()
                                          .indexOf(':') +
                                      1,
                                  videoPlayerValue.duration
                                      .toString()
                                      .indexOf('.')),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ]);
          }
        },
      ),
    );
  }
}
