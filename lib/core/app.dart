import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/fonts.dart';
import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: Fonts.medium,
        splashColor: AppColors.lightBrown.withOpacity(0.15),
      ),
    );
  }
}
