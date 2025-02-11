import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_field_custom.dart';
import 'package:endol/common/button_primary.dart';
import '../../../../app_navigation/navigation.dart';
import '../../../common/dialogs.dart';
import '../../../constants/app_images.dart';
import 'login_screen.dart';
import '../services/firebase_auth_services.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/strings.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  // final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _signUp() async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        if (mounted) {
          Navigation.navigateTo(
            context,
            const LoginScreen(),
          );
        }
      } else {
        log('error');
      }
    } catch (e) {
      log('$e');
      if (mounted) {
        Dialogs.dialogInform(context, '$e', () {
          Navigator.pop(context);
        }, Strings.ok);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.pureWhite,
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, screenHeight * 0.1, 20, 0),
            child: Column(
              children: [
                // Logo
                // ExtendedImage.asset(
                //   AppImages.logo,
                //   scale: 6,
                // ),
                const SizedBox(height: 100),
                // Title and slogan
                ExtendedImage.asset(AppImages.endolSign),
                gapH16,
                ExtendedImage.asset(AppImages.slogan),
                gapH48,
                // FullName input
                // TextFieldCustom(
                //   hint: Strings.fullName,
                //   controller: fullNameController,
                //   inputType: TextInputType.emailAddress,
                // ),
                // gapH16,
                // Email Address input
                TextFieldCustom(
                  hint: Strings.emailAddress,
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                gapH16,
                //  Password input
                TextFieldCustom(
                  hint: Strings.password,
                  controller: passwordController,
                  inputType: TextInputType.text,
                ),
                gapH32,
                // Create Account button
                ButtonPrimary(
                  height: 61,
                  width: 240,
                  text: Strings.createAccount,
                  function: () {
                    _signUp();
                  },
                  active: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
