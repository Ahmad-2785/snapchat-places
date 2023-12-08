import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/data/model/place_details_model.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  const VideoDisplay({super.key});

  @override
  State<VideoDisplay> createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  final Map<String, dynamic> arguments = Get.arguments;
  Map<String, dynamic> displayName = {"text": "", "languageCode": "en"};
  Location location = Location(lat: 0, lng: 0);
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;
  bool isLoading = true;

  initVideo() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(arguments['placeData']['url']),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    futureController = controller!.initialize();
  }

  Future getInitailData(placeId) async {
    //Get place Info from Google API
    final result = await PlacesServices.getPlaceSimpleData(placeId);

    setState(() {
      displayName = result['displayName'];
      location = Location(
          lat: result['location']['latitude'],
          lng: result['location']['longitude']);
      isLoading = false;
    });
  }

  @override
  void initState() {
    initVideo();
    getInitailData(arguments['placeData']['placeId']);
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
          if (snapshot.connectionState == ConnectionState.waiting ||
              isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stack(children: [
              Positioned.fill(child: VideoPlayer(controller!)),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  height: 120,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.homePage,
                            arguments: {'location': location});
                      },
                      child: Text(
                        displayName['text'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
