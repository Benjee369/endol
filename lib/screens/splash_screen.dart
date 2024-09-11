import 'package:endol/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigation.navigateAndReplace(
        context,
        const LoginScreen(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.thatBrown,
      body: Stack(
        children: [
          Center(
            child: TextWidget(
              text: Strings.appName,
              size: 50,
              color: AppColors.pureWhite,
            ),
          )
        ],
      ),
    );
  }
}
