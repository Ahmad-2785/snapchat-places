import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:http/http.dart' as http;
import 'package:snapchat/src/util/reusable_methods.dart';

import '../../../constants/file_constants.dart';
import '../../view_model/services/splash_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late GoogleMapController _mapController;
  String _mapStyle = "";
  Set<Marker> _showMarkers = {};

  CameraPosition currentPos = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14,
  );

  bool _isCameraReCenter = false;
  CameraPosition initialLocation = const CameraPosition(
    target: LatLng(40.7128, -24.0060),
    zoom: 14,
  );

  static const CameraPosition _kLake = CameraPosition(
      target: LatLng(40.7128, -24.0060), zoom: 19.151926040649414);

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
    print("=======================");
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
    setState(() {
      initialLocation = CameraPosition(
          target: LatLng(mylocation.latitude, mylocation.longitude), zoom: 15);
    });
    await _mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(mylocation.latitude, mylocation.longitude),
            zoom: 16.5)));
    print(">>>>>>>>");
    print(mylocation);

    // setState(() {
    //   initialLocation = CameraPosition(
    //       target: LatLng(mylocation.latitude, mylocation.longitude));
    // });
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
          myLocationEnabled: true,
          initialCameraPosition: initialLocation,
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
          onCameraIdle: () {
            setState(() {
              _isCameraReCenter = false;
            });
          },
          markers: _showMarkers,
        ),
        const SizedBox(),
        const Text('Index 2: School', style: TextStyle(color: Colors.black)),
      ][_selectedIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
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
              }
              if (index != 1) {
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
}
