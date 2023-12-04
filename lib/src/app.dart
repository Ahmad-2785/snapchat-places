import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/src/app_state.dart';
import 'package:snapchat/src/app_theme.dart';
import 'res/routes/app_routes.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(builder: (context, appState, child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        getPages: AppRoutes.routes(),
      );
    });
  }
}
