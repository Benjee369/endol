import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/common/text_field_custom.dart';
import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/screens/create_account/email_password_screen.dart';

import '../../common/text_widget.dart';
import '../../constants/app_sizes.dart';
import '../../constants/strings.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

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
              ExtendedImage.asset('assets/images/endol.png'),
              gapH16,
              ExtendedImage.asset('assets/images/slogan.png'),
              gapH48,
              // First Name input
              TextFieldCustom(
                hint: Strings.firstName,
                controller: firstNameController,
                inputType: TextInputType.text,
              ),
              gapH16,
              // Last Name input
              TextFieldCustom(
                hint: Strings.lastName,
                controller: lastNameController,
                inputType: TextInputType.text,
              ),
              gapH32,
              // Next button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the next screen
                    Navigation.navigateTo(
                      context,
                      const EmailPasswordScreen(),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        text: Strings.next,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        size: 17,
                      ),
                      gapH8,
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.black,
                      ),
                    ],
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
