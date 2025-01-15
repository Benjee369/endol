import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class CustomPopupMenu extends StatelessWidget {
  final void Function(int value) onSelected;
  final List<PopupMenuItemData> items;

  const CustomPopupMenu({
    super.key,
    required this.onSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppColors.pureWhite,
      offset: const Offset(-10, 50),
      icon: const Icon(Icons.more_vert_outlined),
      onSelected: onSelected,
      itemBuilder: (context) {
        return items
            .map(
              (item) => PopupMenuItem<int>(
                value: item.value,
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: AppColors.thatBrown,
                    ),
                    gapW8,
                    Text(item.label),
                  ],
                ),
              ),
            )
            .toList();
      },
    );
  }
}

class PopupMenuItemData {
  final int value;
  final IconData icon;
  final String label;

  PopupMenuItemData({
    required this.value,
    required this.icon,
    required this.label,
  });
}
