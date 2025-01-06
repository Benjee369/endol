import 'package:endol/common/shimmer_loader.dart';
import 'package:flutter/material.dart';

import '../../../common/text_widget.dart';
import '../../../constants/app_colors.dart';

class HomeAmountWidget extends StatelessWidget {
  final String? title;
  final String? amount;
  final bool? isLoading;
  final Color? textColor;

  const HomeAmountWidget({
    super.key,
    this.title,
    this.amount,
    this.isLoading,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading == true
        ? ShimmerLoading(
            height: size.height * 0.1,
            width: size.width * 0.45,
            borderRadius: 15,
          )
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: AppColors.cream,
            elevation: 0,
            surfaceTintColor: AppColors.cream,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: '$title',
                    fontWeight: FontWeight.bold,
                    color: AppColors.textFieldHint,
                    size: 14,
                  ),
                  TextWidget(
                    text: 'K $amount',
                    fontWeight: FontWeight.bold,
                    size: 22,
                    color: textColor,
                  )
                ],
              ),
            ),
          );
  }
}
