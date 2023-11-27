import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/view/home/home.dart';
import 'package:snapchat/src/view/signin/sign_in.dart';

import '../../res/routes/routes.dart';

class SplashServices {
  static void checkLogin() async {
    Timer(const Duration(milliseconds: 3000), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.off(() => SignIn());
      } else {
        Get.off(() => HomePage());
      }
    });
  }

  static void checkProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? uid = pref.getString('USERID');
    if (uid == null) {
      Get.toNamed(Routes.completeProfile);
    }
  }
}
