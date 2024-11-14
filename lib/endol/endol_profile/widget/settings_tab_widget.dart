import 'package:endol/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../common/text_widget.dart';
import '../../../constants/app_sizes.dart';

class SettingsTabWidget extends StatelessWidget {
  final IconData tabIcon;
  final String tabText;
  final VoidCallback function;

  const SettingsTabWidget({
    super.key,
    required this.tabIcon,
    required this.tabText,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.cream,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const ShapeDecoration(
                color: AppColors.pureWhite,
                shape: CircleBorder(),
              ),
              child: Icon(
                tabIcon,
                color: AppColors.thatBrown.withOpacity(0.9),
              ),
            ),
            gapW16,
            TextWidget(text: tabText),
            const Spacer(),
            const Icon(Icons.chevron_right_outlined),
          ],
        ),
      ),
    );
  }
}
