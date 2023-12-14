import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/data/model/place_details_model.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/util/reusable_methods.dart';
import 'package:snapchat/src/util/utils.dart';
import 'package:snapchat/src/view/home/business_card.dart';
import 'package:snapchat/src/view/home/camera_screen.dart';
import 'package:snapchat/src/view/home/place_search_menu.dart';
import 'package:snapchat/src/view/signin/sign_in.dart';

import '../../../constants/file_constants.dart';
import '../../view_model/services/splash_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List _pendingFollowers = [];
  StreamSubscription<DatabaseEvent>? _sub1;
  StreamSubscription<DatabaseEvent>? _sub2;
  Map<String, Location> receivedLocation =
      Get.arguments ?? {"location": Location(lat: 0, lng: 0)};
  int _selectedIndex = 0;
  var _zoom = 16.5;
  bool _extendBody = true;
  late GoogleMapController _mapController;
  String _mapStyle = "";
  final Set<Marker> _showMarkers = {};
  CameraPosition currentPos = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );
  LatLng _myLocation = const LatLng(0, 0);
  String _takePhotoPlaceId = "";

  @override
  void initState() {
    SplashServices.checkProfile();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString(FileConstants.mapStyle).then((string) {
        _mapStyle = string;
      });
    });
    Timer(const Duration(milliseconds: 1000), () {
      goMyLocation();
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub1?.cancel();
    _sub2?.cancel();
    super.dispose();
  }

  void goMyLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString("USERKEY");
    StreamSubscription<DatabaseEvent> sub1 = FirebaseDatabase.instance
        .ref()
        .child('Followings')
        .orderByChild('following')
        .equalTo(userKey)
        .onValue
        .listen(getFollowers);

    StreamSubscription<DatabaseEvent> sub2 = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(userKey!)
        .onValue
        .listen(checkUser);

    final mylocation = await PlacesServices.determinePosition();
    if (receivedLocation['location']!.lat == 0) {
      await _mapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(mylocation.latitude, mylocation.longitude),
              zoom: _zoom)));
      Marker myLocationMarker = await PlacesServices.getSpecialMarker(
          true, mylocation.latitude, mylocation.longitude);
      setState(() {
        _myLocation = LatLng(mylocation.latitude, mylocation.longitude);
        _showMarkers.add(myLocationMarker);
      });
    } else {
      await _mapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(receivedLocation['location']!.lat,
                  receivedLocation['location']!.lng),
              zoom: 19)));
      Marker newMarker = await PlacesServices.getSpecialMarker(false,
          receivedLocation['location']!.lat, receivedLocation['location']!.lng);
      Marker myLocationMarker = await PlacesServices.getSpecialMarker(
          true, mylocation.latitude, mylocation.longitude);
      setState(() {
        _sub1 = sub1;
        _sub2 = sub2;
        _myLocation = LatLng(mylocation.latitude, mylocation.longitude);
        _showMarkers.add(newMarker);
        _showMarkers.add(myLocationMarker);
      });
    }
  }

  void updateMarkers(CameraPosition position) async {
    double distance = calculateDistance(
      currentPos.target.latitude,
      currentPos.target.longitude,
      position.target.latitude,
      position.target.longitude,
    );
    if (distance < 0.05) {
      return;
    }
    var places = await PlacesServices.getPlaces(position.target, position.zoom);
    if (places.isNotEmpty) {
      for (var place in places) {
        if (_showMarkers.any((marker) => marker.markerId == place['id'])) {
          continue;
        }
        if (place['primaryType'] == null) {
          continue;
        }
        String placeType = PlacesServices.getPlaceType(place['primaryType']);
        if (placeType == "Unknown") {
          continue;
        }
        Marker newMarker = await PlacesServices.getMarker(place);
        final zoom = await _mapController.getZoomLevel();
        setState(() {
          _zoom = zoom;
          currentPos = position;
          _showMarkers.add(newMarker);
        });
      }
    }
  }

  getFollowers(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List pendingFollowers = [];
    if (value is Map) {
      value.forEach((key, value) {
        if (value['status'] == "pending") {
          pendingFollowers.add(value['follower']);
        }
      });
    }

    setState(() {
      _pendingFollowers = pendingFollowers;
    });
  }

  checkUser(DatabaseEvent event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = event.snapshot.value;
    String? userUid;
    bool? disabled;
    if (user is Map) {
      userUid = user['uid'];
      disabled = user['disabled'];
    }
    if (userUid == null) {
      prefs.clear();
      Utils.showSnackBar(
          const Text(
            'Account Issue',
            style: TextStyle(
              color: Color(0xFF0F1D27),
              fontSize: 18,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          const Text(
            'User Account is Deleted by Administrator',
            style: TextStyle(
              color: Color(0xFF566067),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const Icon(
            IconData(0xe237, fontFamily: 'MaterialIcons'),
            color: Color(0xFFFD363B),
            size: 20,
          ),
          color: const Color(0xFFFFEBEB),
          borderColor: const Color(0xFFFD363B));

      Get.off(() => const SignIn());
    }
    if (disabled == true) {
      prefs.clear();
      Utils.showSnackBar(
          const Text(
            'Account Issue',
            style: TextStyle(
              color: Color(0xFF0F1D27),
              fontSize: 18,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          const Text(
            'User Account is Disabled by Administrator',
            style: TextStyle(
              color: Color(0xFF566067),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const Icon(
            IconData(0xe237, fontFamily: 'MaterialIcons'),
            color: Color(0xFFFD363B),
            size: 20,
          ),
          color: const Color(0xFFFFEBEB),
          borderColor: const Color(0xFFFD363B));
      Get.off(() => const SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        showBackDialog(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: _extendBody,
        body: <Widget>[
          Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                compassEnabled: false,
                initialCameraPosition: currentPos,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  _mapController.setMapStyle(_mapStyle);
                },
                minMaxZoomPreference: const MinMaxZoomPreference(14, 22),
                mapToolbarEnabled: false,
                onTap: (LatLng latLng) {
                  print(latLng);
                },
                onCameraMove: (CameraPosition position) {
                  updateMarkers(position);
                },
                markers: _showMarkers,
              ),
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.userOptions);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.23999999463558197),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Center(
                      child: Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: const Icon(
                            Icons.person_outlined,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
              _pendingFollowers.isNotEmpty
                  ? Positioned(
                      top: 40,
                      left: 40,
                      child: Container(
                        width: 20,
                        height: 20,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.red.withOpacity(1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${_pendingFollowers.length}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.settings);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.23999999463558197),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Center(
                      child: Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: const Icon(
                            Icons.settings_outlined,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(),
          FutureBuilder(
            future: availableCameras(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cameras = snapshot.data as List<CameraDescription>;
                final backCameras = cameras
                    .where(
                        (cam) => cam.lensDirection == CameraLensDirection.back)
                    .toList();
                if (backCameras.isNotEmpty) {
                  return CameraScreen(
                      cameraDescription: backCameras[0],
                      placeId: _takePhotoPlaceId);
                } else {
                  return const Center(
                    child: Text("No Camera Found!"),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("ERROR : ${snapshot.error}"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ][_selectedIndex],
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 88,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              left: BorderSide(color: Theme.of(context).colorScheme.secondary),
              top: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.secondary),
              right: BorderSide(color: Theme.of(context).colorScheme.secondary),
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(56),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt_outlined),
                  label: '',
                ),
              ],
              backgroundColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: const Color(0XFFA7ACAF),
              selectedFontSize: 0,
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.onBackground,
              onTap: (int index) {
                switch (index) {
                  case 0:
                    setState(() {
                      _extendBody = true;
                    });
                    if (_selectedIndex == index) {
                      _mapController.moveCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(
                                  _myLocation.latitude, _myLocation.longitude),
                              zoom: _zoom)));
                    }
                  case 1:
                    showModal(context);
                  case 2:
                    if (_selectedIndex != index) {
                      showPossiblePositions(context);
                    }
                }
                if (index == 0) {
                  setState(
                    () {
                      _selectedIndex = index;
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showBackDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 1,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Are you sure?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to exist app?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Nevermind',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Exist'),
              onPressed: () {
                Navigator.of(context).pop(true);
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const PlaceSearchMenu();
      },
    );
  }

  void showPossiblePositions(BuildContext context) async {
    final myLocation = await updateMyLocation();
    final places = await PlacesServices.getTakePicturePlaces(myLocation.target);
    var uniqueList = [];
    if (places != null) {
      for (var place in places) {
        if (uniqueList.any((element) => element['id'] == place['id'])) {
          continue;
        }
        uniqueList.add(place);
      }
    }

    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext dialogContext) {
          return Container(
            padding: const EdgeInsets.all(20),
            // color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Please choose the business',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Expanded(
                  child: uniqueList.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          shrinkWrap: true,
                          itemCount: uniqueList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              clipBehavior: Clip.hardEdge,
                              color: Theme.of(context).colorScheme.secondary,
                              elevation: 0,
                              child: InkWell(
                                  onTap: () {
                                    setState(
                                      () {
                                        _extendBody = false;
                                        _selectedIndex = 2;
                                        _takePhotoPlaceId =
                                            uniqueList[index]['id'];
                                      },
                                    );
                                    Navigator.pop(dialogContext);
                                  },
                                  child: BusinessCard(
                                      individualPlace: uniqueList[index])),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                          "There are no businesses around you",
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  updateMyLocation() async {
    final mylocation = await PlacesServices.determinePosition();
    Marker myLocationMarker = await PlacesServices.getSpecialMarker(
        true, mylocation.latitude, mylocation.longitude);
    setState(() {
      _myLocation = LatLng(mylocation.latitude, mylocation.longitude);
      _showMarkers
          .removeWhere((element) => element.markerId.value == "mylocaation");
      _showMarkers.add(myLocationMarker);
    });
    return CameraPosition(
        target: LatLng(mylocation.latitude, mylocation.longitude), zoom: 16.5);
  }
}
