import 'package:endol/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:extended_image/extended_image.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //after waiting for 2 seconds it takes you to the login screen
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        if (mounted) {
          Navigation.navigateAndReplace(
            context,
            const LoginScreen(),
          );
        }
      },
    );
    super.initState();
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
