import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF8F9F9),
      textTheme: const TextTheme(
        bodySmall: TextStyle(
          color: Color(0xFF0F1D27),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: Color(0xFF8B9296),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF0F1D27),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF0F1D27),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
        titleSmall: TextStyle(
          color: Color(0xFF0F1D27),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Color(0xFF6155A6),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
        labelMedium: TextStyle(
          color: Color(0xFF0F1D27),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
      ),
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
        }),
        secondary: const MaterialColor(0xFFFFFFFF, {}),
        onSecondary: const MaterialColor(0xFFECEEEF, {}),
        tertiary: const MaterialColor(0xFFECEEEF, {}),
        onTertiary: const MaterialColor(0xFFECEEEF, {}),
        tertiaryContainer: const MaterialColor(0xFF0F1D27, {}),
        onTertiaryContainer: const MaterialColor(0xFF70787E, {}),
        background: const MaterialColor(0xFFF8F9F9, {}),
        onBackground: const MaterialColor(0xFF000000, {}),
      ));

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0F1D27),
      textTheme: const TextTheme(
        bodySmall: TextStyle(
          color: Color(0xFFF8F9F9),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: Color(0xFFA7ACAF),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: Color(0xFFF8F9F9),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFF8F9F9),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
        titleSmall: TextStyle(
          color: Color(0xFFF8F9F9),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Color(0xFFA7ACAF),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
        labelMedium: TextStyle(
          color: Color(0xFFF8F9F9),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
      ),
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
        error: const MaterialColor(
          0xFFFD363B,
          {
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
          },
        ),
        secondary: const MaterialColor(0xFF25323B, {}),
        onSecondary: const MaterialColor(0xFF3D4850, {}),
        tertiary: const MaterialColor(0xFF25323B, {}),
        onTertiary: const MaterialColor(0xFF566067, {}),
        tertiaryContainer: const MaterialColor(0xFFF8F9F9, {}),
        onTertiaryContainer: const MaterialColor(0xFF8B9296, {}),
        background: const MaterialColor(0xFF0F1D27, {}),
        onBackground: const MaterialColor(0xFFFFFFFF, {}),
      ));
}
