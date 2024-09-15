import 'package:flutter/material.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_field_custom.dart';
import 'package:endol/common/button_primary.dart';
import '../../constants/app_sizes.dart';
import '../../constants/strings.dart';

class EmailPasswordScreen extends StatefulWidget {
  const EmailPasswordScreen({super.key});

  @override
  State<EmailPasswordScreen> createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.pureWhite,
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, screenHeight * 0.1, 20, 0),
          child: Column(
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                scale: 6,
              ),
              const SizedBox(height: 100),
              // Title and slogan
              Image.asset('assets/images/endol.png'),
              gapH16,
              Image.asset('assets/images/slogan.png'),
              gapH48,
              // Email Address input
              TextFieldCustom(
                hint: Strings.emailAddress,
                controller: emailController,
                inputType: TextInputType.emailAddress,
              ),
              gapH16,
              // Password input
              TextFieldCustom(
                hint: Strings.password,
                controller: passwordController,
                inputType: TextInputType.text,

              ),
              gapH16,
              // Confirm Password input
              TextFieldCustom(
                hint: Strings.confirmPassword,
                controller: confirmPasswordController,
                inputType: TextInputType.text,

              ),
              gapH32,
              // Create Account button
              ButtonPrimary(
                height: 61,
                width: 240,
                text: Strings.createAccount,
                function: () {
                  // Handle account creation logic
                },
                active: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
