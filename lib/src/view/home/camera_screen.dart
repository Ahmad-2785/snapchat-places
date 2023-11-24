import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapchat/src/res/routes/routes.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.cameraDescription,
  });

  final CameraDescription cameraDescription;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.cameraDescription,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
            
                  final image = await _controller.takePicture();
            

                  Get.toNamed(Routes.displayPicureScreen,
                      arguments: {'imagePath': image.path});
                } catch (e) {
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),
        )
      ]),
    );
  }
}
