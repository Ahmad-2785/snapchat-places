import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snapchat/src/data/model/pharmacy_details_model.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/util/reusable_methods.dart';
import 'package:snapchat/src/view/home/camera_screen.dart';

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

  late GoogleMapController _mapController;
  String _mapStyle = "";
  Set<Marker> _showMarkers = {};

  CameraPosition currentPos = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );
  CameraPosition _myLocation =
      const CameraPosition(target: LatLng(0, 0), zoom: 15);

  void updateMarkers(CameraPosition position) async {
    double distance = calculateDistance(
      currentPos.target.latitude,
      currentPos.target.longitude,
      position.target.latitude,
      position.target.longitude,
    );
    if (distance < 0.15) {
      return;
    }
    var places = await PlacesServices.getPlaces(position.target, position.zoom);
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
      setState(() {
        currentPos = position;
        _showMarkers.add(newMarker);
      });
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
              zoom: 16.5)));
      Marker myLocationMarker = await PlacesServices.getSpecialMarker(
          true, mylocation.latitude, mylocation.longitude);
      setState(() {
        _myLocation = CameraPosition(
            target: LatLng(mylocation.latitude, mylocation.longitude),
            zoom: 16.5);
        _showMarkers.add(myLocationMarker);
      });
    } else {
      await _mapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(receivedLocation['location']!.lat,
                  receivedLocation['location']!.lng),
              zoom: 17)));
      Marker newMarker = await PlacesServices.getSpecialMarker(false,
          receivedLocation['location']!.lat, receivedLocation['location']!.lng);
      Marker myLocationMarker = await PlacesServices.getSpecialMarker(
          true, mylocation.latitude, mylocation.longitude);
      setState(() {
        _myLocation = CameraPosition(
            target: LatLng(mylocation.latitude, mylocation.longitude),
            zoom: 16.5);
        _showMarkers.add(newMarker);
        _showMarkers.add(myLocationMarker);
      });
    }
  }

  @override
  void initState() {
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
      body: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
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
        const SizedBox(),
        FutureBuilder(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final cameras = snapshot.data as List<CameraDescription>;
              final backCameras = cameras
                  .where((cam) => cam.lensDirection == CameraLensDirection.back)
                  .toList();
              if (backCameras.length > 0) {
                return CameraScreen(cameraDescription: backCameras[0]);
              } else {
                return Center(
                  child: Text("No Camera Found!"),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text("ERROR : ${snapshot.error}"),
              );
            } else {
              return Center(
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
                  if (_selectedIndex == index) {
                    print('go to my location');
                  }
                case 1:
                  showModal(context);
                case 2:
                  showCameraModal(context);
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
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  void showCameraModal(BuildContext context) async {
    final myLocation = await updateMyLocation();
    final places = await PlacesServices.getTakePicturePlaces(myLocation.target);
    print(places.length);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  updateMyLocation() async {
    final mylocation = await PlacesServices.determinePosition();
    Marker myLocationMarker = await PlacesServices.getSpecialMarker(
        true, mylocation.latitude, mylocation.longitude);
    setState(() {
      _myLocation = CameraPosition(
          target: LatLng(mylocation.latitude, mylocation.longitude),
          zoom: 16.5);
      _showMarkers
          .removeWhere((element) => element.markerId.value == "mylocaation");
      _showMarkers.add(myLocationMarker);
    });
    return CameraPosition(
        target: LatLng(mylocation.latitude, mylocation.longitude), zoom: 16.5);
  }
}
