import 'package:endol/app_navigation/home_navigation.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/screens/create_account/create_account_screen.dart';
import 'package:endol/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/strings.dart';
import 'package:endol/common/text_field_custom.dart';
import 'package:endol/common/button_primary.dart';
import 'package:extended_image/extended_image.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;
  bool isButtonActive = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, screenHeight * 0.1, 20, 0),
          child: Column(
            children: [
              ExtendedImage.asset(
                'assets/images/logo.png',
                scale: 6,
              ),
              const SizedBox(height: 100),
              ExtendedImage.asset('assets/images/endol.png'),
              gapH16,
              ExtendedImage.asset("assets/images/slogan.png"),
              gapH48,
              //Email Text box
              TextFieldCustom(
                hint: Strings.emailAddress,
                controller: emailController,
                inputType: TextInputType.text,
              ),
              gapH16,
              //Password Text box
              TextFieldCustom(
                hint: Strings.password,
                controller: passwordController,
                inputType: TextInputType.text,
              ),
              gapH16,
              //Login Button
              ButtonPrimary(
                height: 61,
                width: 180,
                text: Strings.login,
                function: () {
                  Navigation.navigateAndReplace(
                    context,
                    const HomeNavigation(),
                  );
                },
                active: true,
              ),
              gapH12,
              const InkWell(
                child: TextWidget(
                  text: Strings.forgotPassword,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Create account Button
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: ButtonPrimary(
                      height: 61,
                      text: Strings.createAccount,
                      function: () {
                        Navigation.navigateAndReplace(
                          context,
                          const CreateAccountScreen(),
                        );
                      },
                      active: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
