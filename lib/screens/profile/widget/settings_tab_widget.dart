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
      child: Column(
        children: [
          Row(
            children: [
              Icon(tabIcon),
              gapW16,
              TextWidget(text: tabText),
              const Spacer(),
              const Icon(Icons.chevron_right_outlined),
            ],
          ),
          gapH16,
          const Divider(
            height: 2,
          ),
        ],
      ),
    );
  }
}
