import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({
    super.key,
  });

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Map<String, dynamic> arguments = Get.arguments;
  bool isLoading = false;

  void saveImage() async {
    try {
      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/${DateTime.now()}.png';

      // Save to filesystem
      final File newImage = await File(arguments['imagePath']!).copy(filename);
      print(dir);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: newImage.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      print(">>>>>>");
      print(finalPath);
    } catch (e) {
      print(e);
    }
  }

  uploadImage() async {
    setState(() {
      isLoading = true;
    });
    final fireUser = FirebaseAuth.instance.currentUser;
    final uid = fireUser!.uid;

    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('stories')
        .child('${arguments['placeId']}/${DateTime.now()}');
    final metaData = SettableMetadata(
      contentType: 'image/jpeg', // Set the desired content type here
    );
    final uploadTask =
        firebaseStorageRef.putFile(File(arguments['imagePath']!), metaData);
    final taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    DatabaseReference newEntryRef =
        FirebaseDatabase.instance.ref().child('Stories').push();
    Map<String, dynamic> newData = {
      'userUid': uid,
      'placeId': arguments['placeId'],
      'url': downloadURL,
      'contentType': 'image/jpeg',
    };
    newEntryRef.set(newData).then((_) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.file(File(arguments['imagePath']!)).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.23999999463558197),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                  left: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  top: BorderSide(
                      width: 1, color: Theme.of(context).colorScheme.secondary),
                  right: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveImage();
                    },
                    style: ButtonStyle(
                      padding:
                          const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.all(14)),
                      alignment: Alignment.center,
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.onSecondary),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const CircleBorder(),
                      ),
                    ),
                    child: Icon(
                      Icons.file_download_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        uploadImage();
                      },
                      style: const ButtonStyle(
                          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 24)),
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFF6155A6)),
                          fixedSize: MaterialStatePropertyAll(Size(120, 48))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Send',
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
                            Icons.keyboard_arrow_right,
                            size: 24,
                            color: Colors.white,
                          )
                        ],
                      )),
                ],
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
        ],
      ),
    );
  }
}
