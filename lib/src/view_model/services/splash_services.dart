import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/view/home/home.dart';
import 'package:snapchat/src/view/profile/complete_profile.dart';
import 'package:snapchat/src/view/signin/sign_in.dart';

class SplashServices {
  static void checkLogin() async {
    Timer(const Duration(milliseconds: 3000), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.off(() => const SignIn());
      } else {
        Get.off(() => const HomePage());
      }
    });
  }

  static void checkProfile() async {
    //get my user key
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myKey = prefs.getString("USERKEY");
    if (myKey == null) {
      Get.off(() => const CompleteProfile());
      return;
    }

    //get user data
    String? userUid;
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot snapshot = await ref.child(myKey).get();
    final user = snapshot.value;
    if (user is Map) {
      userUid = user['uid'];
    }
    if (userUid == null) {
      prefs.clear();
      Get.off(() => const SignIn());
    }
  }
}
