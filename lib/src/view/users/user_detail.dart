import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/view/details/video_play.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  bool isLoading = true;
  final Map<String, dynamic> arguments = Get.arguments;
  StreamSubscription<DatabaseEvent>? sub;
  List _followers = [];
  List _followings = [];
  late StreamSubscription<DatabaseEvent> _sub1;
  late StreamSubscription<DatabaseEvent> _sub2;
  StreamSubscription<DatabaseEvent>? _sub3;
  StreamSubscription<DatabaseEvent>? _sub4;
  String followStatus = "unfollow";
  List<Map> _stories = [];
  String _myKey = "";
  String _userKey = "";
  String _username = "";
  String _avatar = "";
  bool _isPublic = true;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    sub?.cancel();
    _sub1.cancel();
    _sub2.cancel();
    _sub3?.cancel();
    _sub4?.cancel();
    super.dispose();
  }

  void getUserData() async {
    //get my user key
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myKey = prefs.getString("USERKEY") ?? "";

    //get user data
    String username = "";
    String avatar = "";
    String userUid = "";
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot snapshot = await ref.child(arguments['userKey']).get();
    final user = snapshot.value;
    if (user is Map) {
      username = user['username'];
      avatar = user['avatar'];
      userUid = user['uid'];
    }
    StreamSubscription<DatabaseEvent> sub1 = FirebaseDatabase.instance
        .ref()
        .child('Followings')
        .orderByChild('follower')
        .equalTo(arguments['userKey'])
        .onValue
        .listen(getFollowings);
// get follow status
    DatabaseReference followRef =
        FirebaseDatabase.instance.ref().child('Followings');
    DatabaseEvent event =
        await followRef.orderByChild('follower').equalTo(myKey).once();
    dynamic snapshotValue = event.snapshot.value;
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        if (value['following'] == arguments['userKey']) {
          setState(() {
            _sub4 = followRef
                .child(key)
                .child('status')
                .onValue
                .listen(unfollowActionStatus);
          });
        }
      });
    }
    // get stories data
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference usersRef = databaseReference.child('Stories');
    DatabaseEvent event2 =
        await usersRef.orderByChild('userUid').equalTo(userUid).once();
    DataSnapshot snapshot2 = event2.snapshot;
    dynamic snapshotValue2 = snapshot2.value;
    List<Map> stories = [];
    if (snapshotValue2 is Map) {
      snapshotValue2.forEach((key, value) {
        stories.add(value);
      });
    }
    setState(() {
      // get ispublic in realtime
      sub = ref
          .child(arguments['userKey'])
          .child('isPublic')
          .onValue
          .listen(getPublicStatus);
      _sub1 = sub1;
      _sub2 = FirebaseDatabase.instance
          .ref()
          .child('Followings')
          .orderByChild('following')
          .equalTo(arguments['userKey'])
          .onValue
          .listen(getFollowers);
      _stories = stories;
      _myKey = myKey;
      _username = username;
      _avatar = avatar;
      _userKey = arguments['userKey'];
      isLoading = false;
    });
  }

  void unfollowActionStatus(DatabaseEvent event) {
    String data = event.snapshot.value != null
        ? event.snapshot.value as String
        : "unfollow";
    setState(() {
      followStatus = data;
    });
  }

  void followActionStatus(DatabaseEvent event) {
    String data = event.snapshot.value != null
        ? event.snapshot.value as String
        : "unfollow";
    setState(() {
      followStatus = data;
    });
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
              setState(() {
                _sub3 = ref.onValue.listen(followActionStatus);
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
            if (value['following'] == _userKey) {
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

  getFollowers(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List followers = [];
    if (value is Map) {
      value.forEach((key, value) {
        if (value['status'] == "follow") {
          followers.add(value['follower']);
        }
      });
    }

    setState(() {
      _followers = followers;
    });
  }

  getFollowings(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List followings = [];
    if (value is Map) {
      value.forEach((key, value) {
        if (value['status'] == "follow") {
          followings.add(value['following']);
        }
      });
    }

    setState(() {
      _followings = followings;
    });
  }

  void getPublicStatus(DatabaseEvent event) {
    final data = event.snapshot.value;
    setState(() {
      _isPublic = data as bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 24,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Text('User info',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 120,
                  child: Stack(children: [
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFFFF7FC),
                          shape: OvalBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFECEEEF))),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 96,
                          backgroundImage: NetworkImage(_avatar),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: followAction,
                        child: Container(
                          padding: EdgeInsets.only(left: 50),
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            radius: 20,
                            child: followStatus == "unfollow"
                                ? const Icon(
                                    Icons.favorite_outline,
                                    color: Color(0xFFFFABE1),
                                    size: 24,
                                  )
                                : followStatus == "follow"
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Color(0xFFFFABE1),
                                        size: 24,
                                      )
                                    : const Icon(
                                        Icons.pending_actions,
                                        color: Color(0xFFFFABE1),
                                        size: 24,
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _username,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFFA7ACAF),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
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
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_alt,
                      size: 18,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    Text(
                      " ${_followers.length} ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      " followers ",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      '\u2022',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      " ${_followings.length} ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      " following",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 0, bottom: 20),
                    child: (!_isPublic && followStatus != "follow")
                        ? Center(
                            child: Text(
                              "User's profile is private",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          )
                        : _stories.isNotEmpty
                            ? FutureBuilder<List<Map>>(
                                future: Future.value(_stories),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return GridView.builder(
                                        itemCount: snapshot.data?.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 0.6),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                bottom: 16,
                                                top: 0),
                                            child: snapshot.data![index]
                                                        ['contentType'] ==
                                                    'image/jpeg'
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes.imageDisplay,
                                                          arguments: {
                                                            'placeData':
                                                                snapshot.data![
                                                                    index],
                                                          });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                snapshot.data![
                                                                        index]
                                                                    ['url']),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes.videoDisplay,
                                                          arguments: {
                                                            'placeData':
                                                                snapshot.data![
                                                                    index],
                                                          });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        children: [
                                                          VideoPlay(
                                                              pathh: snapshot
                                                                      .data![
                                                                  index]['url']),
                                                          const Icon(
                                                            Icons.play_arrow,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          );
                                        });
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              )
                            : Center(
                                child: Text(
                                  "There is no story",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                  ),
                ),
              ],
            ),
    );
  }
}
