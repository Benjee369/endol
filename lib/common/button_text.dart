import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/fonts.dart';
import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? textColor;
  final double? textSize;

  const ButtonText({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.textSize,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap.call();
      },
      child: icon == null
          ? TextWidget(
              text: text,
              fontFamily: Fonts.bold,
              color: textColor ?? AppColors.cream,
              size: textSize ?? 14,
            )
          : Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                ),
                const SizedBox(
                  width: 10,
                ),
                TextWidget(
                  text: text,
                  fontFamily: Fonts.bold,
                  color: textColor ?? AppColors.cream,
                  size: 14,
                )
              ],
            ),
    );
  }
}
