import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:snapchat/src/res/routes/app_routes.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/util/utils.dart';

import '../shared_pref/shared_pref.dart';

class FirebaseServices {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> signInWithApple() async {
    try {
      //generateNonce
      int length = 32;
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      final rawNonce =
          List.generate(length, (_) => charset[random.nextInt(charset.length)])
              .join();

      //sha2560fString
      final bytes = utf8.encode(rawNonce);
      final digest = sha256.convert(bytes);
      final nonce = digest.toString();
      ;

      //applesignin
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      await FirebaseAuth.instance
          .signInWithCredential(oauthCredential)
          .then((authCred) {
        if (authCred != null) {
          Get.toNamed(Routes.completeProfile);
        }
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            const Text(
              'Error',
              style: TextStyle(
                color: Color(0xFF0F1D27),
                fontSize: 18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            Text(
              Utils.extractFirebaseError(error.toString()),
              style: const TextStyle(
                color: Color(0xFF566067),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const Icon(
              IconData(0xf04be, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ));
        return;
      });
    } catch (e) {
      Utils.showSnackBar(
          const Text(
            'Error',
            style: TextStyle(
              color: Color(0xFF0F1D27),
              fontSize: 18,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          Text(
            Utils.extractFirebaseError(e.toString()),
            style: const TextStyle(
              color: Color(0xFF566067),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const Icon(
            IconData(0xe237, fontFamily: 'MaterialIcons'),
            color: Color(0xFFFD363B),
            size: 20,
          ));
    }
  }

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
            Get.toNamed(Routes.completeProfile);
          }).onError((error, stackTrace) {
            Utils.showSnackBar(
                const Text(
                  'Error',
                  style: TextStyle(
                    color: Color(0xFF0F1D27),
                    fontSize: 18,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Text(
                  Utils.extractFirebaseError(error.toString()),
                  style: const TextStyle(
                    color: Color(0xFF566067),
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const Icon(
                  IconData(0xf04be, fontFamily: 'MaterialIcons'),
                  color: Colors.red,
                ));
            return;
          });
        }
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            const Text(
              'Error',
              style: TextStyle(
                color: Color(0xFF0F1D27),
                fontSize: 18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            Text(
              Utils.extractFirebaseError(e.toString()),
              style: const TextStyle(
                color: Color(0xFF566067),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const Icon(
              IconData(0xf04be, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ));
        return;
      });
    } catch (e) {
      Utils.showSnackBar(
          const Text(
            'Error',
            style: TextStyle(
              color: Color(0xFF0F1D27),
              fontSize: 18,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          Text(
            Utils.extractFirebaseError(e.toString()),
            style: const TextStyle(
              color: Color(0xFF566067),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const Icon(
            IconData(0xf04be, fontFamily: 'MaterialIcons'),
            color: Colors.red,
          ));
    }
  }
}
