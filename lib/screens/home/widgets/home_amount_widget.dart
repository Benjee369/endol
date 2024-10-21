import 'package:flutter/material.dart';

import '../../../common/text_widget.dart';
import '../../../constants/app_colors.dart';

class HomeAmountWidget extends StatelessWidget {
  final String? title;
  final String? amount;

  const HomeAmountWidget({super.key, this.title, this.amount});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: AppColors.cream,
      elevation: 0,
      surfaceTintColor: AppColors.cream,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenWidth * 0.02,
        ),
        child: Column(
          children: [
            TextWidget(
              text: '$title',
              fontWeight: FontWeight.bold,
            ),
            TextWidget(
              text: 'MWK$amount',
              fontWeight: FontWeight.bold,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
