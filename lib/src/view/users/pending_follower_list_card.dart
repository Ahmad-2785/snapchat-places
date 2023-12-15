import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/res/routes/routes.dart';

class PendingFollowersListsCard extends StatefulWidget {
  const PendingFollowersListsCard({super.key, required this.userKey});
  final String userKey;

  @override
  State<PendingFollowersListsCard> createState() =>
      _PendingFollowersListsCardState();
}

class _PendingFollowersListsCardState extends State<PendingFollowersListsCard> {
  bool _disbled = false;
  bool isLoading = true;
  String _myKey = "";
  String _userKey = "";
  String _username = "";
  String _avatar = "";
  bool _isPublic = true;
  late StreamSubscription<DatabaseEvent> _sub;
  StreamSubscription<DatabaseEvent>? _sub4;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getUserInfo();
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    _sub4?.cancel();
    super.dispose();
  }

  void getUserInfo() async {
    //get my user key
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myKey = prefs.getString("USERKEY") ?? "";

    //get user data
    String username = "";
    String avatar = "";
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot snapshot = await ref.child(widget.userKey).get();
    final user = snapshot.value;
    if (user is Map) {
      username = user['username'];
      avatar = user['avatar'];
    }
    // get ispublic in realtime
    StreamSubscription<DatabaseEvent> sub = ref
        .child(widget.userKey)
        .child('isPublic')
        .onValue
        .listen(getPublicStatus);
    // get disabled in realtime
    StreamSubscription<DatabaseEvent> sub4 = ref
        .child(widget.userKey)
        .child('disabled')
        .onValue
        .listen(getDisbleStatus);
    setState(() {
      _sub4 = sub4;
      _sub = sub;
      _myKey = myKey;
      _username = username;
      _avatar = avatar;
      _userKey = widget.userKey;
      isLoading = false;
    });
  }

  getPublicStatus(DatabaseEvent event) {
    final data = event.snapshot.value;
    setState(() {
      _isPublic = data as bool;
    });
  }

  getDisbleStatus(DatabaseEvent event) {
    final data = event.snapshot.value;
    setState(() {
      _disbled = data as bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
            height: 120, child: Center(child: CircularProgressIndicator()))
        : Container(
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
                      side:
                          const BorderSide(width: 1, color: Color(0xFFECEEEF)),
                      borderRadius: BorderRadius.circular(76),
                    ),
                  ),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_avatar),
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
                  height: 120,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _username,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(
                          width: 36,
                        ),
                        _disbled
                            ? const SizedBox()
                            : Container(
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x05000000),
                                      blurRadius: 16,
                                      offset: Offset(0, 4),
                                      spreadRadius: -4,
                                    )
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      padding: const MaterialStatePropertyAll<
                                              EdgeInsetsGeometry>(
                                          EdgeInsets.only(right: 14, left: 14)),
                                    ),
                                    onPressed: accept,
                                    child: const Text(
                                      "Accept",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // widget.userKey['shortFormattedAddress'],
                          _isPublic ? "Public" : "Private",
                          style: TextStyle(
                            color: _isPublic
                                ? const Color(0xFF26B468)
                                : const Color(0xFFFD363B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0.09,
                          ),
                        ),
                        _disbled
                            ? const Text(
                                "disabled",
                                style: TextStyle(
                                  color: Color(0xFFFD363B),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 3,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  Get.toNamed(Routes.userDetail,
                                      arguments: {'userKey': _userKey});
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                )),
                        Container(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                                spreadRadius: -4,
                              )
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          height: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.secondary),
                                padding: const MaterialStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.only(right: 12, left: 12)),
                              ),
                              onPressed: decline,
                              child: Text(
                                "Decline",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          );
  }

  void accept() async {
    DatabaseReference followRef =
        FirebaseDatabase.instance.ref().child('Followings');
    DatabaseEvent event =
        await followRef.orderByChild('follower').equalTo(_userKey).once();
    dynamic snapshotValue = event.snapshot.value;
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        if (value['following'] == _myKey) {
          FirebaseDatabase.instance
              .ref()
              .child('Followings')
              .child(key)
              .update({
            "status": 'follow',
          });
        }
      });
    }
  }

  void decline() async {
    DatabaseReference followRef =
        FirebaseDatabase.instance.ref().child('Followings');
    DatabaseEvent event =
        await followRef.orderByChild('follower').equalTo(_userKey).once();
    dynamic snapshotValue = event.snapshot.value;
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        if (value['following'] == _myKey) {
          FirebaseDatabase.instance
              .ref()
              .child('Followings')
              .child(key)
              .remove();
        }
      });
    }
  }
}
