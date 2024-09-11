import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/fonts.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback function;
  final Color? color;
  final double? width;
  final double? textSize;
  final bool? active;
  final bool isLoading; // Add this line to accept isLoading

  const ButtonPrimary({
    super.key,
    required this.text,
    required this.function,
    this.color,
    this.textSize,
    this.active,
    this.width,
    this.isLoading = false, // Add this line to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: active == true && !isLoading
            ? function
            : null, // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: active == true
              ? (isLoading ? AppColors.cream : color ?? AppColors.thatBrown)
              : AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: isLoading // Display a CircularProgressIndicator when loading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : TextWidget(
                  text: text,
                  size: textSize ?? 16,
                  color: Colors.white,
                  fontFamily: Fonts.semiBold,
                ),
        ),
      ),
    );
  }
}
