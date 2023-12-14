import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/view/details/video_play.dart';
import 'package:snapchat/src/view/users/followings.dart';
import 'package:snapchat/src/view/users/user_search_menu.dart';

import '../../res/routes/routes.dart';

class UserOptions extends StatefulWidget {
  const UserOptions({super.key});

  @override
  State<UserOptions> createState() => _UserOptionsState();
}

class _UserOptionsState extends State<UserOptions> {
  List<Map> _stories = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  String _username = "";
  bool _isPublic = true;
  bool nightmode = true;
  String _userKey = "";
  String _avatar = "";
  List _followers = [];
  List _pendingFollowers = [];
  List _pendingFollowings = [];
  List _followings = [];
  late SharedPreferences _prefs;
  late StreamSubscription<DatabaseEvent> _sub1;
  late StreamSubscription<DatabaseEvent> _sub2;
  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  void dispose() {
    _sub1.cancel();
    _sub2.cancel();
    super.dispose();
  }

  getFollowers(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List followers = [];
    List pendingFollowers = [];
    if (value is Map) {
      value.forEach((key, value) {
        if (value['status'] == "follow") {
          followers.add(value['follower']);
        } else {
          pendingFollowers.add(value['follower']);
        }
      });
    }

    setState(() {
      _followers = followers;
      _pendingFollowers = pendingFollowers;
    });
  }

  getFollowings(DatabaseEvent event) async {
    var value = event.snapshot.value;
    List followings = [];
    List pendingFollowings = [];
    if (value is Map) {
      value.forEach((key, value) {
        if (value['status'] == "follow") {
          followings.add(value['following']);
        } else {
          pendingFollowings.add(value['following']);
        }
      });
    }

    setState(() {
      _followings = followings;
      _pendingFollowings = pendingFollowings;
    });
  }

  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("USERNAME");
    final avatar = prefs.getString("AVATARURL");
    final isPublic = prefs.getBool("ISPUBLIC");
    final userKey = prefs.getString("USERKEY");
    final userUid = prefs.getString("UID");
    StreamSubscription<DatabaseEvent> sub1 = FirebaseDatabase.instance
        .ref()
        .child('Followings')
        .orderByChild('follower')
        .equalTo(userKey)
        .onValue
        .listen(getFollowings);
    StreamSubscription<DatabaseEvent> sub2 = FirebaseDatabase.instance
        .ref()
        .child('Followings')
        .orderByChild('following')
        .equalTo(userKey)
        .onValue
        .listen(getFollowers);
    // get stories data
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference usersRef = databaseReference.child('Stories');
    DatabaseEvent event =
        await usersRef.orderByChild('userUid').equalTo(userUid).once();
    DataSnapshot snapshot = event.snapshot;
    dynamic snapshotValue = snapshot.value;
    List<Map> stories = [];
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        stories.add(value);
      });
    }

    setState(() {
      _stories = stories;
      _sub1 = sub1;
      _sub2 = sub2;
      isLoading = false;
      _prefs = prefs;
      _username = username ?? "";
      _avatar = avatar ?? "";
      _isPublic = isPublic ?? true;
      _userKey = userKey ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : <Widget>[
              Column(
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
                        Text('My status',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 100,
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
                    ]),
                  ),
                  const SizedBox(
                    height: 8,
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
                      Icon(
                        Icons.people_alt,
                        size: 18,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          print("hello world");
                        },
                        child: Row(
                          children: [
                            Text(
                              " ${_followers.length} ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              " followers ",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\u2022',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          print("hello world");
                        },
                        child: Row(
                          children: [
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: 76,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Public',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Switch(
                            activeTrackColor:
                                Theme.of(context).colorScheme.primary,
                            inactiveTrackColor: const Color(0xFFC5C9CC),
                            value: _isPublic,
                            onChanged: setPrivacy)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 20),
                      child: _stories.isNotEmpty
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
                                                          'placeData': snapshot
                                                              .data![index],
                                                        });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                                          'placeData': snapshot
                                                              .data![index],
                                                        });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.bottomLeft,
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
              const SizedBox(),
              Followings(
                  followers: _followers,
                  pendingFollowers: _pendingFollowers,
                  followings: _followings,
                  pendingFollowings: _pendingFollowings),
            ][_selectedIndex],
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            left: BorderSide(color: Theme.of(context).colorScheme.secondary),
            top: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.secondary),
            right: BorderSide(color: Theme.of(context).colorScheme.secondary),
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(56),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _pendingFollowers.isEmpty
                    ? const Icon(Icons.favorite_border)
                    : Badge(
                        label: Text("${_pendingFollowers.length}"),
                        child: const Icon(Icons.favorite_border),
                      ),
                label: '',
              ),
            ],
            backgroundColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: const Color(0XFFA7ACAF),
            selectedFontSize: 0,
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.onBackground,
            onTap: (int index) {
              switch (index) {
                case 0:
                  setState(
                    () {
                      _selectedIndex = index;
                    },
                  );
                case 1:
                  showModal(context);
                case 2:
                  setState(
                    () {
                      _selectedIndex = index;
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void setPrivacy(bool value) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$_userKey");
    await ref.update({
      "isPublic": value,
    });
    _prefs.setBool('ISPUBLIC', value);
    setState(() {
      _isPublic = value;
    });
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return UserSearchMenu(
          username: _username,
        );
      },
    );
  }
}
