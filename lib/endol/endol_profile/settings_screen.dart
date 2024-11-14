import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/endol/endol_profile/widget/settings_tab_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../endol_auth/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;

  Future<void> _signOut() async {
    if (mounted) {
      isLoading = true;
    }
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigation.navigateAndReplace(
          context,
          const LoginScreen(),
        );
      }
      if (mounted) {
        isLoading = false;
      }
    } catch (e) {
      if (mounted) {
        isLoading = false;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidget(text: '$e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        centerTitle: true,
        title: const TextWidget(
          text: 'Settings',
          color: AppColors.thatBrown,
          fontWeight: FontWeight.bold,
          size: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            children: [
              gapH24,
              const CircleAvatar(
                radius: 51,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.lightBrown,
                ),
              ),
              const TextWidget(text: 'John Doe'),
              gapH24,
              const Align(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: 'General',
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapH16,
              SettingsTabWidget(
                tabIcon: Icons.person_off,
                tabText: 'Account',
                function: () {},
              ),
              gapH16,
              SettingsTabWidget(
                tabIcon: Icons.person_off,
                tabText: 'Account',
                function: () {},
              ),
              gapH32,
              const Align(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: 'General',
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapH16,
              SettingsTabWidget(
                tabIcon: Icons.logout,
                tabText: 'Log Out',
                function: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
