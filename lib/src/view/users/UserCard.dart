import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/res/routes/routes.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.userKey});
  final userKey;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String followStatus = "unfollow";
  bool isLoading = true;
  String _myKey = "";
  String _userKey = "";
  String _username = "";
  String _avatar = "";
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getUserInfo();
    });
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
    DatabaseReference ref2 = ref.child(widget.userKey).child('isPublic');
    ref2.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        _isPublic = data as bool;
      });
    });
    // get follow status
    DatabaseReference followRef =
        FirebaseDatabase.instance.ref().child('Followings');
    DatabaseEvent event =
        await followRef.orderByChild('follower').equalTo(myKey).once();
    dynamic snapshotValue = event.snapshot.value;
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        if (value['following'] == widget.userKey) {
          DatabaseReference ref3 = followRef.child(key).child('status');
          ref3.onValue.listen((DatabaseEvent event) {
            String data = event.snapshot.value != null
                ? event.snapshot.value as String
                : "unfollow";
            setState(() {
              followStatus = data;
            });
          });
        }
      });
    }
    setState(() {
      _myKey = myKey;
      _username = username;
      _avatar = avatar;
      _userKey = widget.userKey;
      isLoading = false;
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _username,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
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
                              onPressed: followAction,
                              child: Text(
                                followStatus == "unfollow"
                                    ? "Follow"
                                    : followStatus == "follow"
                                        ? "Unfollow"
                                        : "Pending",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
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
                        IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.userDetail,
                                  arguments: {'userKey': _userKey});
                            },
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: Theme.of(context).colorScheme.onBackground,
                            ))
                      ],
                    ),
                  ],
                )),
              ],
            ),
          );
  }

  void followAction() async {
    switch (followStatus) {
      case "unfollow":
        String status = _isPublic ? "follow" : "pending";
        DatabaseReference newEntryRef =
            FirebaseDatabase.instance.ref().child('Followings').push();
        Map<String, dynamic> newData = {
          'follower': _myKey,
          'following': _userKey,
          'status': status,
        };
        String dataKey = newEntryRef.key ?? "";
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child('Followings')
            .child(dataKey)
            .child('status');
        newEntryRef.set(newData).then((_) => {
              ref.onValue.listen((DatabaseEvent event) {
                String data = event.snapshot.value != null
                    ? event.snapshot.value as String
                    : "unfollow";
                setState(() {
                  followStatus = data;
                });
              })
            });

        break;
      default:
        DatabaseReference followRef =
            FirebaseDatabase.instance.ref().child('Followings');
        DatabaseEvent event =
            await followRef.orderByChild('follower').equalTo(_myKey).once();
        dynamic snapshotValue = event.snapshot.value;
        if (snapshotValue is Map) {
          snapshotValue.forEach((key, value) {
            if (value['following'] == widget.userKey) {
              FirebaseDatabase.instance
                  .ref()
                  .child('Followings')
                  .child(key)
                  .remove();
            }
          });
        }
        break;
    }
  }
}
