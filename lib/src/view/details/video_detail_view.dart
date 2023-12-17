import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoDetailView extends StatefulWidget {
  const VideoDetailView({super.key});

  @override
  State<VideoDetailView> createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends State<VideoDetailView> {
  final Map<String, dynamic> arguments = Get.arguments;
  StreamSubscription<DatabaseEvent>? _sub;
  String _userKey = "";
  String _storyKey = "";
  bool isReported = false;
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(arguments['data']['value']['url']),
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
    getInitialData();
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    controller!.dispose();
    super.dispose();
  }

  void getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = prefs.getString("USERKEY") ?? "";
    // get is Reported status
    StreamSubscription<DatabaseEvent> sub = FirebaseDatabase.instance
        .ref()
        .child('Reports')
        .orderByChild('storyKey')
        .equalTo(arguments['data']['key'])
        .onValue
        .listen(checckFollowStatus);
    setState(() {
      _userKey = userKey;
      _sub = sub;
      _storyKey = arguments['data']['key'];
    });
  }

  checckFollowStatus(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List reportings = [];
    if (value is Map) {
      value.forEach((key, value) {
        reportings.add(key);
      });
    }

    setState(() {
      isReported = reportings.isNotEmpty;
    });
  }

  report() {
    DatabaseReference newEntryRef =
        FirebaseDatabase.instance.ref().child('Reports').push();
    Map<String, dynamic> newData = {
      'userKey': _userKey,
      'storyKey': _storyKey,
    };
    newEntryRef.set(newData);
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
              isReported
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: Text(
                          "This media is reported",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    )
                  : Positioned(
                      top: 40,
                      right: 20,
                      child: ElevatedButton(
                          onPressed: report,
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll<
                                      EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 24)),
                              alignment: Alignment.center,
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.black.withOpacity(0.4)),
                              fixedSize: const MaterialStatePropertyAll(
                                  Size(120, 48))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Report',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              Icon(
                                Icons.report_outlined,
                                size: 20,
                                color: Colors.white,
                              )
                            ],
                          )),
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
