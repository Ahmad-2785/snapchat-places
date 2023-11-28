import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageDetailView extends StatefulWidget {
  const ImageDetailView({super.key});

  @override
  State<ImageDetailView> createState() => _ImageDetailViewState();
}

class _ImageDetailViewState extends State<ImageDetailView> {
  final Map<String, dynamic> arguments = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: NetworkImage(arguments['path']),
        fit: BoxFit.cover,
      ))),
    );
  }
}
