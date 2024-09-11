import 'package:endol/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/strings.dart';
import 'package:endol/common/text_field_custom.dart';
import 'package:endol/common/button_primary.dart';

import 'home_screen.dart';

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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 270, 20, 0),
          child: Column(
            children: [
              const TextWidget(
                text: Strings.welcome,
                size: 40,
              ),
              gapH16,
              TextFieldCustom(
                hint: Strings.emailAddress,
                controller: emailController,
                inputType: TextInputType.text,
              ),
              gapH16,
              TextFieldCustom(
                hint: Strings.password,
                controller: passwordController,
                inputType: TextInputType.text,
              ),
              gapH8,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const TextWidget(text: Strings.rememberMe),
                    ],
                  ),
                  const InkWell(
                    child: TextWidget(
                      text: Strings.forgotPassword,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              ButtonPrimary(
                text: Strings.login,
                function: () {
                  if (isButtonActive == true) {
                    Navigation.navigateTo(
                      context,
                      const HomeScreen(),
                    );
                  }
                },
                active: true,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 19, 0, 19),
                child: Divider(
                  color: AppColors.pureWhite,
                  height: 2.0,
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const TextWidget(text: Strings.dontHaveAnAccount),
              //     InkWell(
              //       onTap: Navigation.navigateTo(
              //         context,
              //         const CreateAccountScreen(),
              //       ),
              //       child: const TextWidget(
              //         text: Strings.createAccount,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
