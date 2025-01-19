import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class PaymentTypeRadioList<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  const PaymentTypeRadioList({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            _customRadioButton,
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.thatBrown : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.thatBrown : AppColors.pureWhite,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.black,
          ),
          gapW4,
          TextWidget(
            text: leading,
            color: isSelected ? Colors.white : AppColors.black,
            size: 15,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
