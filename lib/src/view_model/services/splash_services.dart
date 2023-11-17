import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/routes/routes.dart';

class SplashServices {
  static void checkLogin() async {
    Timer(const Duration(milliseconds: 3000), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.toNamed(Routes.signIn);
      } else {
        Get.toNamed(Routes.homePage);
      }
    });
  }

  static void checkProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? uid = pref.getString('UID');
    if (uid == null) {
      Get.toNamed(Routes.completeProfile);
    }
  }
}
