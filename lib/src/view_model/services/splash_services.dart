import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/routes/routes.dart';


class SplashServices{
  static void checkLogin()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String? uid=pref.getString('TOKEN');
    Timer(const Duration(milliseconds: 3000), () {
      if(uid==null){
        Get.toNamed(Routes.signIn);
      }else{
        Get.toNamed(Routes.homePage);
      }
    });
  }
}