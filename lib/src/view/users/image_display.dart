import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/data/model/place_details_model.dart';
import 'package:snapchat/src/res/routes/routes.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({super.key});

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  final Map<String, dynamic> arguments = Get.arguments;
  bool isLoading = true;
  Map<String, dynamic> displayName = {"text": "", "languageCode": "en"};
  Location location = Location(lat: 0, lng: 0);
  @override
  void initState() {
    getInitailData(arguments['placeData']['placeId']);
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(arguments['placeData']['url']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
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
                ],
              ),
            ),
    );
  }
}
