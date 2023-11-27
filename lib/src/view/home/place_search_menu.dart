import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/view/home/business_card.dart';
import 'package:snapchat/src/view/profile/components/custom_input_decoration.dart';

class PlaceSearchMenu extends StatefulWidget {
  const PlaceSearchMenu({
    super.key,
  });

  @override
  State<PlaceSearchMenu> createState() => _PlaceSearchMenuState();
}

class _PlaceSearchMenuState extends State<PlaceSearchMenu> {
  List placesLists = [];
  final TextEditingController _textFieldController = TextEditingController();
  void searchPlaces() async {
    final searchText = _textFieldController.value.text;
    if (searchText != "") {
      final places = await PlacesServices.getPlacesBySearch(searchText);
      var filteredPlaces = [];
      if (places != null) {
        for (var place in places) {
          if (!PlacesServices.includedTypes().contains(place['primaryType'])) {
            continue;
          }
          filteredPlaces.add(place);
        }
      }
      print(filteredPlaces.length);
      setState(() {
        placesLists = filteredPlaces;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 50,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderTextField(
                controller: _textFieldController,
                name: 'search',
                showCursor: false,
                onEditingComplete: () {
                  setState(() {
                    placesLists = [];
                  });
                  searchPlaces();
                },
                decoration: CustomInputDecoration(
                    'Search',
                    const Icon(
                      Icons.search,
                      color: Color(0xFFA7ACAF),
                      size: 24,
                    ),
                    fillColor: Color(0xFFECEEEF)),
              )),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _textFieldController.clear();
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFECEEEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: placesLists.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 0),
                    shrinkWrap: true,
                    itemCount: placesLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        // clipBehavior is necessary because, without it, the InkWell's animation
                        // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                        // This comes with a small performance cost, and you should not set [clipBehavior]
                        // unless you need it.
                        clipBehavior: Clip.hardEdge,
                        color: Color(0xFFFFFFFF),
                        elevation: 0,
                        child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.details, arguments: {
                                'placeID': placesLists[index]['id']
                              });
                            },
                            child: businessCard(
                                individualPlace: placesLists[index])),
                      );
                    },
                  )
                : const Center(child: Text("There are no places")),
          ),
        ],
      ),
    );
  }
}

