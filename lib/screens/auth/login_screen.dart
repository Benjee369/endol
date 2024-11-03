import 'dart:developer';
import 'package:endol/app_navigation/home_navigation.dart';
import 'package:endol/common/dialogs.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/strings.dart';
import 'package:endol/common/text_field_custom.dart';
import 'package:endol/common/button_primary.dart';
import 'package:extended_image/extended_image.dart';

import 'create_account_screen.dart';
import 'services/firebase_auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isButtonActive = false;
  bool isPasswordHidden = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  //LOGIN DETAILS
  //benjaminphiri369@gmail.com
  //malawi123

  //adrianmalika@gmail.com
  //malawi1234

  void _signIn() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
        log('Login Success');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Navigation.navigateAndReplace(
            context,
            const HomeNavigation(),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: TextWidget(text: 'An error occurred during login'),
            ),
          );
        }
      }
    } catch (e) {
      log('Failed to login: $e');
      if (mounted) {
        Dialogs.dialogInform(context, '$e', () {
          Navigator.pop(context);
        }, Strings.ok);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
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
                    dontShowText: isPasswordHidden,
                    toggleObscure: toggleVisibility,
                  ),
                  gapH16,
                  //Login Button
                  ButtonPrimary(
                    height: 61,
                    width: 180,
                    text: Strings.login,
                    isLoading: isLoading,
                    function: () {
                      _signIn();
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
                            Navigation.navigateTo(
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
        ),
      ),
    );
  }
}
