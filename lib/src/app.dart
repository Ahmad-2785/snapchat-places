import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'res/routes/app_routes.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: const MaterialColor(0xFF6155A6, {
        50: Color(0xFFEFEEF6),
        100: Color(0xFFDFDDED),
        200: Color(0xFFC0BBDB),
        300: Color(0xFFA099CA),
        400: Color(0xFF8177B8),
        500: Color(0xFF6155A6),
        600: Color(0xFF4E4485),
        700: Color(0xFF3A3364),
        800: Color(0xFF272242),
        900: Color(0xFF001726),
      })).copyWith(
              error: const MaterialColor(0xFFFD363B, {
        50: Color(0xFFFFEBEB),
        100: Color(0xFFFFD7D8),
        200: Color(0xFFFEAFB1),
        300: Color(0xFFFE8689),
        400: Color(0xFFFD5E62),
        500: Color(0xFFFD363B),
        600: Color(0xFFCA2B2F),
        700: Color(0xFF982023),
        800: Color(0xFF651618),
        900: Color(0xFF330B0C),
      }))),
      getPages: AppRoutes.routes(),
    );
  }
}
