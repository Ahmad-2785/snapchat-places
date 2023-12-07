import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  bool isLoading = true;
  final Map<String, dynamic> arguments = Get.arguments;
  String followStatus = "unfollow";
  String _myKey = "";
  String _userKey = "";
  String _username = "";
  String _avatar = "";
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    //get my user key
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myKey = prefs.getString("USERKEY") ?? "";

    //get user data
    String username = "";
    String avatar = "";
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot snapshot = await ref.child(arguments['userKey']).get();
    final user = snapshot.value;
    if (user is Map) {
      username = user['username'];
      avatar = user['avatar'];
    }
    // get ispublic in realtime
    DatabaseReference ref2 = ref.child(arguments['userKey']).child('isPublic');
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
        if (value['following'] == arguments['userKey']) {
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
      _userKey = arguments['userKey'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
