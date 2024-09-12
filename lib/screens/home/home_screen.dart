import 'package:endol/common/text_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/strings.dart';
import 'package:provider/provider.dart';
import '../../providers/current_index_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: Center(
          child: ExtendedImage.asset(
            'assets/images/endol.png',
            scale: 4,
          ),
        ),
      ),
      body: const Center(
        child: TextWidget(
          text: 'Hello',
          size: 80,
        ),
      ),
    );
  }
}
