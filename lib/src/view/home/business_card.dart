import 'package:flutter/material.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';

class BusinessCard extends StatefulWidget {
  const BusinessCard({super.key, required this.individualPlace});
  final individualPlace;
  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  String photoUri = "";
  Future getDetails() async {
    if (widget.individualPlace['photos'] == null) {
    } else {
      final photoName = widget.individualPlace['photos'][0]['name'];
      final photo = await PlacesServices.getBusinessPhoto(photoName);
      setState(() {
        photoUri = photo['photoUri'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    photoUri = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFECEEEF)),
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
                widget.individualPlace['displayName']['text'],
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                widget.individualPlace['shortFormattedAddress'],
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
