import 'package:get/get.dart';
import 'package:snapchat/src/view/home/home.dart';
import 'package:snapchat/src/view/signin/sign_in.dart';
import 'package:snapchat/src/view/intro/splash.dart';

import 'routes.dart';

class AppRoutes{
  static List<GetPage> routes(){
    return [
      GetPage(name: Routes.intro, page: ()=>const SplashPage()),
      GetPage(name: Routes.signIn, page: ()=>const SignIn()),
      GetPage(name: Routes.homePage, page: ()=>const HomePage()),
    ];
  }
}