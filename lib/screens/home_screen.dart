import 'package:endol/common/text_widget.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.cream,
        title: const TextWidget(
          text: 'Endl',
          fontWeight: FontWeight.bold,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.thatBrown,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
    );
  }
}
