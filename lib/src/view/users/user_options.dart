import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/view/users/user_search_menu.dart';

class UserOptions extends StatefulWidget {
  const UserOptions({super.key});

  @override
  State<UserOptions> createState() => _UserOptionsState();
}

class _UserOptionsState extends State<UserOptions> {
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
    super.initState();
    getInitialData();
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
    setState(() {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : <Widget>[
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 88,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 44,
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(
                              width: 20,
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
                        height: 20,
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
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
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
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'My account',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'User name',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
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
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'User privacy',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        height: 76,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Public',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Switch(
                                inactiveTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                activeTrackColor: const Color(0xFFC5C9CC),
                                value: _isPublic,
                                onChanged: setPrivacy)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(),
              const Placeholder(),
            ][_selectedIndex],
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
