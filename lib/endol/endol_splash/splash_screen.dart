import 'dart:developer';

import 'package:endol/app_navigation/home_navigation.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:extended_image/extended_image.dart';

import '../endol_auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkToken();
    super.initState();
  }

  Future _checkToken() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen(
        (User? user) {
          if (user == null) {
            if (mounted) {
              Navigation.navigateAndReplace(
                context,
                const LoginScreen(),
              );
            }
          } else {
            if (mounted) {
              Navigation.navigateAndReplace(
                context,
                const HomeNavigation(),
              );
            }
          }
        },
      );
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, screenHeight * 0.5, 8, 8),
        child: Center(
          child: Column(
            children: [
              ExtendedImage.asset(
                'assets/images/logo.png',
                scale: 1.1,
              ),
              gapH48,
              ExtendedImage.asset('assets/images/endol.png'),
              gapH16,
              ExtendedImage.asset('assets/images/slogan.png'),
            ],
          ),
        ),
      ),
    );
  }
}
