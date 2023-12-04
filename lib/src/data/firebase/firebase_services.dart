import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/util/utils.dart';
import 'package:snapchat/src/view/profile/complete_profile.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class FirebaseServices {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User> signInWithAppleService(
      {List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential = await auth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  static Future<void> signInWithApple() async {
    try {
      final user =
          await signInWithAppleService(scopes: [Scope.email, Scope.fullName]);

      Get.offAll(() => const CompleteProfile());
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
            Get.offAll(() => const CompleteProfile());
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
                  Icons.error,
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
              Icons.error,
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
            Icons.error,
            color: Colors.red,
          ));
    }
  }
}
