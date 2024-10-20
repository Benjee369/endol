import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/constants/fonts.dart';
import 'package:flutter/material.dart';

class AddExpenseTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool? dontShowText;
  final TextInputType inputType;
  final VoidCallback? toggleObscure;
  final Function(String)? onChange;
  final int? maxLength;
  final bool? autoCorrect;
  final String? prefixText;
  final TextCapitalization? textCapitalization;
  const AddExpenseTextField(
      {super.key,
      required this.hint,
      this.toggleObscure,
      this.dontShowText,
      this.textCapitalization,
      this.onChange,
      this.autoCorrect,
      this.prefixText,
      required this.controller,
      required this.inputType,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLength: maxLength,
          autocorrect: autoCorrect ?? true,
          keyboardType: inputType,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          obscureText: dontShowText ?? false,
          textInputAction: TextInputAction.done,
          onChanged: onChange,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20, // Adjust the vertical padding
              horizontal: Sizes.p24, // Adjust the horizontal padding
            ),
            counterText: "",
            filled: true,
            fillColor: AppColors.pureWhite,
            hintText: hint,
            suffixIcon: dontShowText != null
                ? IconButton(
                    icon: Icon(dontShowText!
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      if (toggleObscure != null) {
                        toggleObscure!.call();
                      }
                    },
                  )
                : const SizedBox(),
            prefix: prefixText != null
                ? TextWidget(
                    text: "$prefixText ",
                    color: AppColors.thatBrown,
                  )
                : null,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textFieldHint,
            ),
            //fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 1, color: AppColors.pureWhite),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 1, color: AppColors.pureWhite),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 1, color: AppColors.pureWhite),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(width: 1, color: AppColors.pureWhite),
            ),
          ),
        ),
      ],
    );
  }
}