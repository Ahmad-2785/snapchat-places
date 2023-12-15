import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/data/model/place_details_model.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/view/details/stories.dart';
import 'working_hours.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool isLoading;
  late int follow;
  late bool isFollowed;
  final Map<String, dynamic> arguments = Get.arguments;
  int selectedIndex = 0;
  String placeId = "";
  String formattedAddress = "";
  List<Map> _stories = [];
  Map<String, dynamic> displayName = {"text": "", "languageCode": "en"};
  List photos = [];
  Location location = Location(lat: 0, lng: 0);
  String photoUri = "";
  bool openNow = true;
  List<dynamic> weekdayDescriptions = [];
  StreamSubscription<DatabaseEvent>? _sub;
  StreamSubscription<DatabaseEvent>? _sub1;
  String _userKey = "";
  @override
  void initState() {
    isLoading = true;
    placeId = arguments['placeID'];
    getPlacedetails(arguments['placeID']);
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _sub1?.cancel();

    super.dispose();
  }

  void followAction() async {
    if (isFollowed == true) {
      DatabaseReference followRef =
          FirebaseDatabase.instance.ref().child('PlaceFollowings');
      DatabaseEvent event =
          await followRef.orderByChild('placeId').equalTo(placeId).once();
      dynamic snapshotValue = event.snapshot.value;
      if (snapshotValue is Map) {
        snapshotValue.forEach((key, value) {
          if (value['userKey'] == _userKey) {
            FirebaseDatabase.instance
                .ref()
                .child('PlaceFollowings')
                .child(key)
                .remove();
          }
        });
      }
    } else {
      DatabaseReference newEntryRef =
          FirebaseDatabase.instance.ref().child('PlaceFollowings').push();
      Map<String, dynamic> newData = {
        'userKey': _userKey,
        'placeId': placeId,
      };
      newEntryRef.set(newData);
    }
  }

  getFollowings(DatabaseEvent event) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userKey = pref.getString("USERKEY") ?? "";
    var value = event.snapshot.value;
    List followings = [];
    List myFollowings = [];
    if (value is Map) {
      value.forEach((key, value) {
        if (value['userKey'] == userKey) {
          myFollowings.add(value['userKey']);
        }
        followings.add(value['userKey']);
      });
    }

    setState(() {
      follow = followings.length;
      isFollowed = myFollowings.isNotEmpty;
    });
  }

  Future getPlacedetails(placeId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userKey = pref.getString("USERKEY") ?? "";
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
    // Get following numbers and isFollowed
    StreamSubscription<DatabaseEvent> sub = FirebaseDatabase.instance
        .ref()
        .child('PlaceFollowings')
        .orderByChild('placeId')
        .equalTo(placeId)
        .onValue
        .listen(getFollowings);

    // get stories data
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference usersRef = databaseReference.child('Stories');
    DatabaseEvent event =
        await usersRef.orderByChild('placeId').equalTo(placeId).once();
    DataSnapshot snapshot = event.snapshot;
    dynamic snapshotValue = snapshot.value;
    List<Map> stories = [];
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        stories.add({'key': key, 'value': value});
      });
    }
    setState(() {
      _sub = sub;
      _userKey = userKey;
      _stories = stories;
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
                    height: 98,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 24,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Text('Details',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 100,
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
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              formattedAddress,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            openNow
                                ? const Text(
                                    'Open now',
                                    style: TextStyle(
                                      color: Color(0xFF26B468),
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
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.secondary),
                              padding: const MaterialStatePropertyAll<
                                      EdgeInsetsGeometry>(
                                  EdgeInsets.only(right: 24, left: 24)),
                            ),
                            onPressed: () {
                              followAction();
                            },
                            icon: isFollowed == true
                                ? const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFFFABE1),
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Color(0xFFFFABE1),
                                  ),
                            label: Text(
                              "$follow",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
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
                            color: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
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
                                        ? Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Stories',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer,
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
                                        ? Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Working hours',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer,
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
                        stories: _stories,
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
