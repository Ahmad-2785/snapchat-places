import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:snapchat/src/res/routes/routes.dart';

class PlacesServices {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static getBusinessPhoto(String photoName) async {
    String url =
        'https://places.googleapis.com/v1/$photoName/media?maxHeightPx=100&maxWidthPx=100&key=AIzaSyAuiY-se4dvIZJNPHFGlkR42DqfxC-BLUg&skipHttpRedirect=true';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status code ${response.statusCode}');
    }
  }

  static getPlaceDetails(String placeId) async {
    String url = 'https://places.googleapis.com/v1/places/$placeId';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': 'AIzaSyAuiY-se4dvIZJNPHFGlkR42DqfxC-BLUg',
      'X-Goog-FieldMask':
          'id,displayName,photos,shortFormattedAddress,location,regularOpeningHours',
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status code ${response.statusCode}');
    }
  }

  static getPlacesBySearch(text) async {
    const String url = 'https://places.googleapis.com/v1/places:searchText';
    const String apiKey = 'AIzaSyAuiY-se4dvIZJNPHFGlkR42DqfxC-BLUg';
    final Map<String, dynamic> data = {
      "textQuery": text,
      // "excludedPrimaryTypes": excludedTypes(),
      "maxResultCount": 20,
      "rankPreference": "DISTANCE",
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'places.id,places.displayName,places.primaryType,places.photos,places.shortFormattedAddress',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      return jsonDecode(response.body)['places'];
    } catch (e) {
      print('Error: $e');
    }
  }

  static getPlaces(target, zoom) async {
    const String url = 'https://places.googleapis.com/v1/places:searchNearby';
    const String apiKey = 'AIzaSyAuiY-se4dvIZJNPHFGlkR42DqfxC-BLUg';
    final Map<String, dynamic> data = {
      "includedPrimaryTypes": includedTypes(),
      "includedTypes": includedPrimaryTypes(),
      "excludedPrimaryTypes": excludedTypes(),
      "maxResultCount": 20,
      "rankPreference": "DISTANCE",
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': target.latitude,
            'longitude': target.longitude
          },
          'radius': (18 - zoom) * 130.0 + 300.0,
        },
      },
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'places.id,places.primaryType,places.displayName,places.location',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      return jsonDecode(response.body)['places'];
    } catch (e) {
      print('Error: $e');
    }
  }

  static getTakePicturePlaces(target) async {
    const String url = 'https://places.googleapis.com/v1/places:searchNearby';
    const String apiKey = 'AIzaSyAuiY-se4dvIZJNPHFGlkR42DqfxC-BLUg';
    final Map<String, dynamic> data = {
      "includedPrimaryTypes": includedTypes(),
      "includedTypes": includedPrimaryTypes(),
      "excludedPrimaryTypes": excludedTypes(),
      "maxResultCount": 5,
      "rankPreference": "DISTANCE",
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': target.latitude,
            'longitude': target.longitude
          },
          'radius': 50.0,
        },
      },
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'places.id,places.displayName,places.primaryType,places.photos,places.shortFormattedAddress',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      return jsonDecode(response.body)['places'];
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<Marker> getMarker(place) async {
    String placeType = PlacesServices.getPlaceType(place['primaryType']);
    String markerIconUrl = getMarkerIconUrl(placeType);
    ByteData data = await rootBundle.load(markerIconUrl);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 100, targetWidth: 100);
    ui.FrameInfo fi = await codec.getNextFrame();

    ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);

    Marker newmarker = Marker(
      markerId: MarkerId(place['id']),
      position:
          LatLng(place['location']['latitude'], place['location']['longitude']),
      icon: BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List()),
      onTap: () {
        print(place['displayName']['text']);
      },
      infoWindow: InfoWindow(
          // given title for marker
          title: place['displayName']['text'],
          onTap: () {
            Get.toNamed(Routes.details, arguments: {'placeID': place['id']});
          }),
    );

    return newmarker;
  }

  static Future<Marker> getSpecialMarker(isMine, langitude, longitude) async {
    String markerIconUrl = isMine
        ? 'assets/images/markers/my_location.png'
        : 'assets/images/markers/targeted_location.png';
    ByteData data = await rootBundle.load(markerIconUrl);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: isMine ? 150 : 100, targetWidth: isMine ? 150 : 100);
    ui.FrameInfo fi = await codec.getNextFrame();

    ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);

    Marker newmarker = Marker(
      markerId: isMine
          ? const MarkerId("mylocaation")
          : const MarkerId("targetedlocation"),
      position: LatLng(langitude, longitude),
      icon: BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List()),
      onTap: () {},
    );

    return newmarker;
  }

  static String getMarkerIconUrl(String placeType) {
    switch (placeType) {
      case 'Culture':
        return 'assets/images/markers/Culture.png';
      case 'Automotive':
        return 'assets/images/markers/Automotive.png';
      case 'Entertainment':
        return 'assets/images/markers/Entertainment.png';
      case 'Food':
        return 'assets/images/markers/Food.png';
      case 'Drink':
        return 'assets/images/markers/Drink.png';
      case 'Health':
        return 'assets/images/markers/Health.png';
      case 'Drug':
        return 'assets/images/markers/Drug.png';
      case 'Lodging':
        return 'assets/images/markers/Lodging.png';
      case 'Worship':
        return 'assets/images/markers/Worship.png';
      case 'Shopping':
        return 'assets/images/markers/Shopping.png';
      case 'Clothing':
        return 'assets/images/markers/Clothing.png';
      case 'Services':
        return 'assets/images/markers/Services.png';
      case 'Sports':
        return 'assets/images/markers/Sports.png';
      default:
        return 'assets/images/markers/default.png';
    }
  }

  static String getPlaceType(String input) {
    List<String> culture = ['art_gallery', 'museum', 'performing_arts_theater'];
    List<String> automotive = [
      'car_dealer',
      'car_rental',
      'car_repair',
      'car_wash',
      'electric_vehicle_charging_station',
      'gas_station',
      'parking',
      'rest_stop'
    ];
    List<String> entertainment = [
      'amusement_center',
      'amusement_park',
      'aquarium',
      'banquet_hall',
      'bowling_alley',
      'casino',
      'community_center',
      'convention_center',
      'cultural_center',
      'dog_park',
      'event_venue',
      'hiking_area',
      'historical_landmark',
      'marina',
      'movie_rental',
      'movie_theater',
      'national_park',
      'night_club',
      'park',
      'tourist_attraction',
      'visitor_center',
      'wedding_venue',
      'zoo',
    ];
    List<String> drink = [
      'bar',
      'coffee_shop',
      'cafe',
      'ice_cream_shop',
    ];
    List<String> food = [
      'american_restaurant',
      'bakery',
      'barbecue_restaurant',
      'brazilian_restaurant',
      'breakfast_restaurant',
      'brunch_restaurant',
      'chinese_restaurant',
      'fast_food_restaurant',
      'french_restaurant',
      'greek_restaurant',
      'hamburger_restaurant',
      'indian_restaurant',
      'indonesian_restaurant',
      'italian_restaurant',
      'japanese_restaurant',
      'korean_restaurant',
      'lebanese_restaurant',
      'meal_delivery',
      'meal_takeaway',
      'mediterranean_restaurant',
      'mexican_restaurant',
      'middle_eastern_restaurant',
      'pizza_restaurant',
      'ramen_restaurant',
      'restaurant',
      'sandwich_shop',
      'seafood_restaurant',
      'spanish_restaurant',
      'steak_house',
      'sushi_restaurant',
      'thai_restaurant',
      'turkish_restaurant',
      'vegan_restaurant',
      'vegetarian_restaurant',
      'vietnamese_restaurant',
    ];
    List<String> health = [
      'dental_clinic',
      'dentist',
      'doctor',
      'hospital',
      'medical_lab',
      'physiotherapist',
      'spa',
    ];
    List<String> drug = [
      'drugstore',
      'pharmacy',
    ];
    List<String> lodging = [
      'bed_and_breakfast',
      'campground',
      'camping_cabin',
      'cottage',
      'extended_stay_hotel',
      'farmstay',
      'guest_house',
      'hostel',
      'hotel',
      'lodging',
      'motel',
      'private_guest_room',
      'resort_hotel',
      'rv_park',
    ];
    List<String> worship = [
      'church',
      'hindu_temple',
      'mosque',
      'synagogue',
    ];
    List<String> shopping = [
      'auto_parts_store',
      'bicycle_store',
      'book_store',
      'cell_phone_store',
      'convenience_store',
      'department_store',
      'discount_store',
      'electronics_store',
      'furniture_store',
      'gift_shop',
      'grocery_store',
      'hardware_store',
      'home_goods_store',
      'home_improvement_store',
      'jewelry_store',
      'liquor_store',
      'market',
      'pet_store',
      'shopping_mall',
      'sporting_goods_store',
      'store',
      'supermarket',
      'wholesaler',
    ];
    List<String> clothing = [
      'clothing_store',
      'shoe_store',
    ];
    List<String> services = [
      'barber_shop',
      'beauty_salon',
      'cemetery',
      'child_care_agency',
      'consultant',
      'courier_service',
      'electrician',
      'florist',
      'funeral_home',
      'hair_care',
      'hair_salon',
      'insurance_agency',
      'laundry',
      'lawyer',
      'locksmith',
      'moving_company',
      'painter',
      'plumber',
      'real_estate_agency',
      'roofing_contractor',
      'storage',
      'tailor',
      'telecommunications_service_provider',
      'travel_agency',
      'veterinary_care',
    ];
    List<String> sports = [
      'athletic_field',
      'fitness_center',
      'golf_course',
      'gym',
      'playground',
      'ski_resort',
      'sports_club',
      'sports_complex',
      'stadium',
      'swimming_pool',
    ];

    if (culture.contains(input)) {
      return 'Culture';
    } else if (automotive.contains(input)) {
      return 'Automotive';
    } else if (entertainment.contains(input)) {
      return 'Entertainment';
    } else if (food.contains(input)) {
      return 'Food';
    } else if (drink.contains(input)) {
      return 'Drink';
    } else if (health.contains(input)) {
      return 'Health';
    } else if (drug.contains(input)) {
      return 'Drug';
    } else if (lodging.contains(input)) {
      return 'Lodging';
    } else if (worship.contains(input)) {
      return 'Worship';
    } else if (services.contains(input)) {
      return 'Services';
    } else if (shopping.contains(input)) {
      return 'Shopping';
    } else if (clothing.contains(input)) {
      return 'Clothing';
    } else if (sports.contains(input)) {
      return 'Sports';
    } else {
      return 'Unknown';
    }
  }

  static List<String> excludedTypes() {
    return [
      "farm",
      "school",
      "university",
      "preschool",
      "secondary_school",
      "library",
      "bank",
      "accounting",
      "atm",
      "city_hall",
      "local_government_office",
      "courthouse",
      "police",
      "embassy",
      "post_office",
      "fire_station",
      "administrative_area_level_1",
      "locality",
      "administrative_area_level_2",
      "postal_code",
      "country",
      "school_district",
      "airport",
      "bus_station",
      "bus_stop",
      "ferry_terminal",
      "heliport",
      "light_rail_station",
      "park_and_ride",
      "subway_station",
      "taxi_stand",
      "train_station",
      "transit_depot",
      "transit_station",
      "truck_stop",
    ];
  }

  static List<String> includedTypes() {
    return [
      'fitness_center',
      'golf_course',
      'gym',
      'sports_club',
      'stadium',
      'swimming_pool',
      'gift_shop',
      'market',
      'shopping_mall',
      'store',
      'supermarket',
      'church',
      'hindu_temple',
      'mosque',
      'synagogue',
      'campground',
      'lodging',
      'motel',
      'doctor',
      'hospital',
      'pharmacy',
      'bar',
      'cafe',
      'coffee_shop',
      'restaurant',
      'art_gallery',
      'museum',
      'parking',
      'amusement_center',
      'bowling_alley',
      'casino',
      'cultural_center',
      'night_club',
      'park',
      'tourist_attraction',
      'wedding_venue',
      'zoo',
    ];
  }

  static List<String> includedPrimaryTypes() {
    return [
      'barber_shop',
      'beauty_salon',
      'cemetery',
      'child_care_agency',
      'consultant',
      'courier_service',
      'electrician',
      'florist',
      'funeral_home',
      'hair_care',
      'hair_salon',
      'insurance_agency',
      'laundry',
      'lawyer',
      'locksmith',
      'moving_company',
      'painter',
      'plumber',
      'real_estate_agency',
      'roofing_contractor',
      'storage',
      'tailor',
      'telecommunications_service_provider',
      'travel_agency',
      'veterinary_care',
    ];
  }
}
