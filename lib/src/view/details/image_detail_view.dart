import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageDetailView extends StatefulWidget {
  const ImageDetailView({super.key});

  @override
  State<ImageDetailView> createState() => _ImageDetailViewState();
}

class _ImageDetailViewState extends State<ImageDetailView> {
  final Map<String, dynamic> arguments = Get.arguments;
  StreamSubscription<DatabaseEvent>? _sub;
  String _userKey = "";
  String _storyKey = "";
  bool isReported = false;

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = prefs.getString("USERKEY") ?? "";
    // get is Reported status
    StreamSubscription<DatabaseEvent> sub = FirebaseDatabase.instance
        .ref()
        .child('Reports')
        .orderByChild('storyKey')
        .equalTo(arguments['data']['key'])
        .onValue
        .listen(checckFollowStatus);
    setState(() {
      _userKey = userKey;
      _sub = sub;
      _storyKey = arguments['data']['key'];
    });
  }

  checckFollowStatus(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List reportings = [];
    if (value is Map) {
      value.forEach((key, value) {
        reportings.add(key);
      });
    }

    setState(() {
      isReported = reportings.isNotEmpty;
    });
  }

  report() {
    DatabaseReference newEntryRef =
        FirebaseDatabase.instance.ref().child('Reports').push();
    Map<String, dynamic> newData = {
      'userKey': _userKey,
      'storyKey': _storyKey,
    };
    newEntryRef.set(newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(arguments['data']['value']['url']),
          fit: BoxFit.cover,
        )),
        child: Stack(children: [
          isReported
              ? const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Text(
                      "This media is reported",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: 40,
                  right: 20,
                  child: ElevatedButton(
                      onPressed: report,
                      style: ButtonStyle(
                          padding: const MaterialStatePropertyAll<
                                  EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 24)),
                          alignment: Alignment.center,
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.black.withOpacity(0.4)),
                          fixedSize:
                              const MaterialStatePropertyAll(Size(120, 48))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Report',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Icon(
                            Icons.report_outlined,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      )),
                ),
        ]),
      ),
    );
  }
}
