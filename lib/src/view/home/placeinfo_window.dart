import 'package:flutter/material.dart';
import 'package:snapchat/constants/space_constants.dart';

class PlaceInfoWindow extends StatefulWidget {
  final place;
  const PlaceInfoWindow({super.key, required this.place});
  @override
  PplaceInfoWindowState createState() => PplaceInfoWindowState();
}

class PplaceInfoWindowState extends State<PlaceInfoWindow> {
  @override
  Widget build(BuildContext context) {
    SpaceConstants.getScreenSize(context);
    return Container(
      padding: const EdgeInsets.all(10),
      width: SpaceConstants.screenSize.width,
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(SpaceConstants.screenSize.width / 7)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.green,
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: Offset(0, 0))
                  ]),
              child: ClipRRect(
                  child: CircleAvatar(
                radius: SpaceConstants.screenSize.width / 7,
                backgroundImage:
                    const AssetImage('assets//images/test_user.jpg'),
              )),
            ),
            const SizedBox(height: SpaceConstants.spacing15),
            Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: SpaceConstants.spacing30),
                elevation: SpaceConstants.elevation30,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: SpaceConstants.spacing10),
                          child: Text(widget.place['displayName'],
                              style: const TextStyle(color: Colors.blue))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: SpaceConstants.spacing10,
                              horizontal: SpaceConstants.spacing10),
                          child: Text(
                            widget.place['displayName'],
                          ))
                    ])),
          ])),
    );
  }
}
