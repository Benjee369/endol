import 'package:endol/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../common/text_widget.dart';

class SettingsTitleWidget extends StatelessWidget {
  final String text;
  const SettingsTitleWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: TextWidget(
        text: text,
        size: 17,
        color: AppColors.textFieldHint,
      ),
    );
  }
}
