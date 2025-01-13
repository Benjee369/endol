import 'package:endol/app_navigation/navigation.dart';
import 'package:endol/common/custom_app_bar.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/endol/endol_profile/screens/budget_management_screen.dart';
import 'package:endol/endol/endol_profile/widget/settings_tab_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../endol_auth/screens/login_screen.dart';
import '../widget/settings_title_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;
  final User? user = FirebaseAuth.instance.currentUser;

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
      appBar: const CustomAppBar(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            children: [
              gapH24,
              Row(
                children: [
                  CircleAvatar(
                    radius: 60.7,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.lightBrown,
                      child: TextWidget(
                        text:
                            '${user!.email?[0].toUpperCase()}${user!.email?[1].toUpperCase()}',
                        color: AppColors.pureWhite,
                        size: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  gapW24,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: user!.email?[0] ?? 'Not authenticated',
                        size: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      TextWidget(text: user?.email ?? 'Not authenticated'),
                    ],
                  ),
                ],
              ),
              gapH24,
              const SettingsTitleWidget(text: 'General'),
              gapH16,
              SettingsTabWidget(
                tabIcon: Icons.person_off,
                tabText: 'Account',
                function: () {},
              ),
              gapH16,
              SettingsTabWidget(
                tabIcon: Icons.money,
                tabText: 'Budget Management',
                function: () {
                  Navigation.navigateTo(
                    context,
                    const BudgetManagementScreen(),
                  );
                },
              ),
              gapH32,
              const SettingsTitleWidget(text: 'General'),
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
