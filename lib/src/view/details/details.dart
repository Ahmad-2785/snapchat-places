import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/data/model/pharmacy_details_model.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/view/details/video_play.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool isLoading;
  final Map<String, dynamic> arguments = Get.arguments;
  int selectedIndex = 0;
  String placeId = "";
  String formattedAddress = "";
  List<Map<String, String>> storiesURLS = [];
  Map<String, dynamic> displayName = {"text": "", "languageCode": "en"};
  List photos = [];
  Location location = Location(lat: 0, lng: 0);
  String photoUri = "";
  bool openNow = true;
  List<dynamic> weekdayDescriptions = [];

  Future getPlacedetails(placeId) async {
    //Get place Info from Google API
    final result = await PlacesServices.getPlaceDetails(placeId);
    if (result['photos'] == null) {
    } else {
      final photoName = result['photos'][0]['name'];
      final photo = await PlacesServices.getBusinessPhoto(photoName);
      setState(() {
        photoUri = photo['photoUri'];
      });
    }

    // Get Stories URLS from firestorage

    final storageref =
        FirebaseStorage.instance.ref().child('stories').child(placeId);
    final ListResult results = await storageref.listAll();
    final List<Reference> items = results.items;
    final List<Map<String, String>> downloadURLS = [];
    for (var i = 0; i < items.length; i++) {
      final download = await items[i].getDownloadURL();
      final metadata = await items[i].getMetadata();
      final contentType = metadata.contentType;

      downloadURLS.add({
        'download': download,
        'type': contentType?.startsWith('image/') == true ? 'image' : 'video'
      });
    }
    print(downloadURLS);
    setState(() {
      placeId = result['id'];
      storiesURLS = downloadURLS;
      displayName = result['displayName'];
      formattedAddress = result['shortFormattedAddress'];
      location = Location(
          lat: result['location']['latitude'],
          lng: result['location']['longitude']);
      if (result['regularOpeningHours'] != null) {
        openNow = result['regularOpeningHours']['openNow'];
      }
      if (result['regularOpeningHours'] != null) {
        weekdayDescriptions =
            result['regularOpeningHours']['weekdayDescriptions'];
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getPlacedetails(arguments['placeID']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 88,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: const SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 24,
                              )),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Details',
                              style: TextStyle(
                                color: Color(0xFF0F1D27),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.arrow_left_sharp,
                              size: 24,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          padding: const EdgeInsets.all(2),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFECEEEF)),
                              borderRadius: BorderRadius.circular(76),
                            ),
                          ),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: ShapeDecoration(
                              image: photoUri == ""
                                  ? const DecorationImage(
                                      image: AssetImage(
                                        'assets/images/logo_white.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(photoUri),
                                      fit: BoxFit.cover,
                                    ),
                              shape: const OvalBorder(),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x14014672),
                                  blurRadius: 24,
                                  offset: Offset(0, 4),
                                  spreadRadius: -4,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                          height: 76,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              displayName['text'],
                              style: const TextStyle(
                                color: Color(0xFF0F1D27),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              formattedAddress,
                              style: const TextStyle(
                                color: Color(0xFFA7ACAF),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            openNow
                                ? Text(
                                    'Open now',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : const Text(
                                    'Closed now',
                                    style: TextStyle(
                                      color: Color(0xFFFD363B),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                          ],
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // follow and direction button
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFECEEEF)),
                            borderRadius: BorderRadius.circular(48),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                              spreadRadius: -4,
                            )
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        height: 48,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFFFFFFF)),
                              padding:
                                  MaterialStatePropertyAll<EdgeInsetsGeometry>(
                                      EdgeInsets.only(right: 24, left: 24)),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                            label: const Text(
                              '362',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF0F1D27),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFECEEEF)),
                              borderRadius: BorderRadius.circular(48),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                                spreadRadius: -4,
                              )
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          height: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Color(0xFF6155A6)),
                                padding: MaterialStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.only(right: 24, left: 24)),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.homePage,
                                    arguments: {'location': location});
                              },
                              // icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Direction',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: selectedIndex == 0
                                        ? const Color(0xFF0F1D27)
                                        : const Color(0xFFECEEEF)),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Stories',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedIndex == 0
                                      ? const Color(0xFF0F1D27)
                                      : const Color(0xFF70787E),
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: selectedIndex == 1
                                        ? const Color(0xFF0F1D27)
                                        : const Color(0xFFECEEEF)),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Working hours',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedIndex == 1
                                      ? const Color(0xFF0F1D27)
                                      : const Color(0xFF70787E),
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: <Widget>[
                      Stories(
                        storiesURLS: storiesURLS,
                      ),
                      WorkingHours(weekdayDescriptions: weekdayDescriptions)
                    ][selectedIndex],
                  )
                ],
              ),
            ),
    );
  }
}

class WorkingHours extends StatelessWidget {
  const WorkingHours({super.key, required this.weekdayDescriptions});
  final List<dynamic> weekdayDescriptions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFECEEEF)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            //Monday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Monday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[0].substring(8)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[0].substring(8) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Tuesday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tuesday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[1].substring(9)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[1].substring(9) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Wednesday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wednesday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[2].substring(11)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[2].substring(11) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Thursday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thursday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[3].substring(10)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[3].substring(10) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Friday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Friday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[4].substring(8)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[4].substring(8) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Saturday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saturday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[5].substring(10)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[5].substring(10) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Sunday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sunday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[6].substring(8)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[6].substring(8) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ],
    );
  }
}

class Stories extends StatefulWidget {
  const Stories({
    super.key,
    required this.storiesURLS,
  });
  final List<Map<String, String>> storiesURLS;
  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 0),
      child: FutureBuilder<List<Map<String, String>>>(
        future: Future.value(widget.storiesURLS),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.6),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 16, top: 0),
                    child: snapshot.data![index]['type'] == 'image'
                        ? GestureDetector(
                            onTap: () {
                              print("Hello");
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data![index]['download']!),
                                        fit: BoxFit.cover))),
                          )
                        : GestureDetector(
                            onTap: () {
                              print("World");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  VideoPlay(
                                      pathh: snapshot.data![index]['download']),
                                  const Icon(
                                    Icons.play_arrow,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
