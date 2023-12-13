import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static String extractFirebaseError(String error) {
    return error.substring(error.indexOf(']') + 1);
  }

  static void showSnackBar(Text title, Text message, Widget icon,
      {Color color = const Color(0xFFFFEBEB),
      Color borderColor = const Color(0xFFFD363B)}) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: color,
      titleText: title,
      isDismissible: true,
      duration: const Duration(milliseconds: 4000),
      icon: icon,
      borderColor: borderColor,
      messageText: message,
      snackPosition: SnackPosition.TOP,
      borderRadius: 20,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      snackStyle: SnackStyle.FLOATING,
    ));
  }
}
