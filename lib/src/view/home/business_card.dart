import 'package:flutter/material.dart';
import 'package:snapchat/src/data/google_map/places_services.dart';

class businessCard extends StatefulWidget {
  const businessCard({super.key, required this.individualPlace});
  final individualPlace;
  @override
  State<businessCard> createState() => _businessCardState();
}

class _businessCardState extends State<businessCard> {
  String photoUri = "";
  Future getDetails() async {
    print(">>>>>>>>>>>>>>>>>>");
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
              color: Colors.white,
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
                style: const TextStyle(
                  color: Color(0xFF0F1D27),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.individualPlace['shortFormattedAddress'],
                style: const TextStyle(
                  color: Color(0xFFA7ACAF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
