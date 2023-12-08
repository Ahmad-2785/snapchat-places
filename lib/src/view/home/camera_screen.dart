import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/res/routes/routes.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.cameraDescription,
    required this.placeId,
  });

  final String placeId;
  final CameraDescription cameraDescription;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  bool isLoading = false;
  bool videoRecord = false;
  _recordVideo() async {
    if (_isRecording) {
      setState(() {
        isLoading = true;
      });
      final file = await _controller.stopVideoRecording();
      setState(() {
        _isRecording = false;
        isLoading = false;
      });
      Get.toNamed(Routes.displayVideoScreen,
          arguments: {'filePath': file.path, 'placeId': widget.placeId});
    } else {
      await _controller.prepareForVideoRecording();
      await _controller.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  void initState() {
    _controller = CameraController(
      widget.cameraDescription,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return (!_controller.value.isInitialized)
                  ? Container()
                  : CameraPreview(_controller);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !videoRecord
              ? FloatingActionButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await _initializeControllerFuture;

                      final image = await _controller.takePicture();
                      setState(() {
                        isLoading = false;
                      });
                      Get.toNamed(Routes.displayPicureScreen, arguments: {
                        'imagePath': image.path,
                        'placeId': widget.placeId
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      print(e);
                    }
                  },
                  child: const Icon(Icons.camera_alt),
                )
              : FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(_isRecording ? Icons.stop : Icons.circle),
                  onPressed: () => _recordVideo(),
                ),
        ),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                videoRecord = !videoRecord;
              });
            },
            child: Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.23999999463558197),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
              ),
              child: !videoRecord
                  ? const Icon(
                      Icons.video_camera_back_outlined,
                      size: 20,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ),
      isLoading
          ? Positioned.fill(
              child: Container(
                color: const Color(0xFF8B9296).withOpacity(0.8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    width: 100,
                    height: 100,
                    decoration: ShapeDecoration(
                      // color: Color.fromARGB(255, 41, 3, 255).withOpacity(0.2),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          : const SizedBox()
    ]);
  }
}
