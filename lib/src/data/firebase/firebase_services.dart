import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapchat/src/res/routes/app_routes.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/util/utils.dart';

import '../shared_pref/shared_pref.dart';

class FirebaseServices {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> signInwWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn
          .signIn()
          .then((GoogleSignInAccount? googleSignInAccount) async {
        if (googleSignInAccount != null) {
          // Get the GoogleSignInAuthentication object
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          // Create an AuthCredential object
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          );

          await auth.signInWithCredential(credential).then((value) {
            print(value);

            // final String str = value.user!.email.toString();
            // final String node = str.substring(0, str.indexOf('@'));
            Get.toNamed(Routes.completeProfile);
            // database.ref('Users').child(node).set({
            //   'name': value.user!.displayName,
            //   'email': value.user!.email,
            // }).then((val) {
            //   Utils.showSnackBar(
            //       'Login',
            //       'Successfully Login',
            //       const Icon(
            //         IconData(0xf04be, fontFamily: 'MaterialIcons'),
            //         color: Colors.red,
            //       ));
            //   UserPref.setUser(value.user!.displayName!, value.user!.email!,
            //       "NOPASSWORD", node, value.user!.uid);
            // }).onError((error, stackTrace) {
            //   Utils.showSnackBar(
            //       'Error',
            //       Utils.extractFirebaseError(error.toString()),
            //       const Icon(
            //         IconData(0xf04be, fontFamily: 'MaterialIcons'),
            //         color: Colors.red,
            //       ));
            //   return;
            // });
          }).onError((error, stackTrace) {
            Utils.showSnackBar(
                'Error',
                Utils.extractFirebaseError(error.toString()),
                const Icon(
                  IconData(0xf04be, fontFamily: 'MaterialIcons'),
                  color: Colors.red,
                ));
            return;
          });
        }
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            'Error',
            Utils.extractFirebaseError(error.toString()),
            const Icon(
              IconData(0xf04be, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ));
        return;
      });
    } catch (e) {
      Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(e.toString()),
          const Icon(
            IconData(0xf04be, fontFamily: 'MaterialIcons'),
            color: Colors.red,
          ));
    }
  }
}
