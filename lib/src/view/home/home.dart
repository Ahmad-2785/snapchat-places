import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snapchat/src/data/model/pharmacy_details_model.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/util/reusable_methods.dart';
import 'package:snapchat/src/view/home/business_card.dart';
import 'package:snapchat/src/view/home/camera_screen.dart';
import 'package:snapchat/src/view/home/place_search_menu.dart';

import '../../../constants/file_constants.dart';
import '../../view_model/services/splash_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void goMyLocation() async {
    final mylocation = await PlacesServices.determinePosition();
    // setState(() {
    //   currentPos = CameraPosition(
    //       target: LatLng(mylocation.latitude, mylocation.longitude), zoom: 15);
    // });
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
        _myLocation = LatLng(mylocation.latitude, mylocation.longitude);
        _showMarkers.add(newMarker);
        _showMarkers.add(myLocationMarker);
      });
    }
  }

  @override
  void initState() {
    print(">>>>>>>>>>");
    super.initState();
    SplashServices.checkProfile();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString(FileConstants.mapStyle).then((string) {
        _mapStyle = string;
      });
    });
    goMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: _extendBody,
      body: <Widget>[
        Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              // myLocationEnabled: true,
              initialCameraPosition: currentPos,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _mapController.setMapStyle(_mapStyle);
              },
              minMaxZoomPreference: const MinMaxZoomPreference(14, 20),
              mapToolbarEnabled: false,
              onTap: (LatLng latLng) {
                print(latLng);
              },
              onCameraMove: (CameraPosition position) {
                updateMarkers(position);
              },
              markers: _showMarkers,
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
                  .where((cam) => cam.lensDirection == CameraLensDirection.back)
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
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            left: BorderSide(color: Color(0xFFECEEEF)),
            top: BorderSide(width: 1, color: Color(0xFFECEEEF)),
            right: BorderSide(color: Color(0xFFECEEEF)),
            bottom: BorderSide(color: Color(0xFFECEEEF)),
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
            backgroundColor: const Color(0xFFF8F9F9),
            unselectedItemColor: const Color(0XFFA7ACAF),
            selectedFontSize: 0,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
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
    );
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFF8F9F9),
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
        backgroundColor: const Color(0xFFF8F9F9),
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
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Please choose the business',
                      textAlign: TextAlign.center,
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
                Expanded(
                  child: uniqueList.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          shrinkWrap: true,
                          itemCount: uniqueList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              // clipBehavior is necessary because, without it, the InkWell's animation
                              // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                              // This comes with a small performance cost, and you should not set [clipBehavior]
                              // unless you need it.
                              clipBehavior: Clip.hardEdge,
                              color: const Color(0xFFFFFFFF),
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
                                  child: businessCard(
                                      individualPlace: uniqueList[index])),
                            );
                          },
                        )
                      : const Center(
                          child: Text("There are no businesses around you")),
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
