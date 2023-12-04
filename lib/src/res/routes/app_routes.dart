import 'package:get/get.dart';
import 'package:snapchat/src/view/details/details.dart';
import 'package:snapchat/src/view/details/image_detail_view.dart';
import 'package:snapchat/src/view/details/video_detail_view.dart';
import 'package:snapchat/src/view/home/display_picture_screen.dart';
import 'package:snapchat/src/view/home/display_video_screen.dart';
import 'package:snapchat/src/view/home/home.dart';
import 'package:snapchat/src/view/profile/complete_profile.dart';
import 'package:snapchat/src/view/settings/privacy_and_policy.dart';
import 'package:snapchat/src/view/settings/settings.dart';
import 'package:snapchat/src/view/settings/terms_and_conditions.dart';
import 'package:snapchat/src/view/signin/components/otp_screen.dart';
import 'package:snapchat/src/view/signin/recovery_profile.dart';
import 'package:snapchat/src/view/signin/sign_in.dart';
import 'package:snapchat/src/view/intro/splash.dart';

import 'routes.dart';

class AppRoutes {
  static List<GetPage> routes() {
    return [
      GetPage(name: Routes.intro, page: () => const SplashPage()),
      GetPage(name: Routes.signIn, page: () => const SignIn()),
      GetPage(name: Routes.otpScreen, page: () => const OtpScreen()),
      GetPage(
          name: Routes.completeProfile, page: () => const CompleteProfile()),
      GetPage(
          name: Routes.recoveryProfile, page: () => const RecoveryProfile()),
      GetPage(name: Routes.homePage, page: () => const HomePage()),
      GetPage(name: Routes.details, page: () => const DetailPage()),
      GetPage(
          name: Routes.displayPicureScreen,
          page: () => const DisplayPictureScreen()),
      GetPage(
          name: Routes.displayVideoScreen,
          page: () => const DisplayVideoScreen()),
      GetPage(
          name: Routes.videoDetailView, page: () => const VideoDetailView()),
      GetPage(
          name: Routes.imageDetailView, page: () => const ImageDetailView()),
      GetPage(name: Routes.settings, page: () => const Settings()),
      GetPage(
          name: Routes.termsAndConditions,
          page: () => const TermsAndConditions()),
      GetPage(
          name: Routes.privacyAndPolicy, page: () => const PrivacyAndPolicy()),
    ];
  }
}
