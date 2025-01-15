import 'package:flutter/material.dart';

import '../../../common/text_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../function/expense_icon.dart';
import 'custom_popup_menu.dart';

class RecentTransactionWidget extends StatelessWidget {
  const RecentTransactionWidget({
    super.key,
    required this.expenses,
    required this.formattedDate,
  });

  final Map<String, dynamic> expenses;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      expenseIcon(expenses['category']),
                      color: AppColors.thatBrown.withOpacity(0.9),
                    ),
                    gapW8,
                    TextWidget(
                      text: expenses['category'],
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                CustomPopupMenu(
                  onSelected: (value) {},
                  items: [
                    PopupMenuItemData(
                      value: 0,
                      icon: Icons.update_rounded,
                      label: 'Update',
                    ),
                    PopupMenuItemData(
                      value: 1,
                      icon: Icons.delete_rounded,
                      label: 'Delete',
                    )
                  ],
                )
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                gapH24,
                TextWidget(
                  text: 'K ${expenses['amount']}',
                  size: 25,
                  fontWeight: FontWeight.bold,
                ),
                gapH12,
                TextWidget(
                  text: formattedDate,
                  color: AppColors.textFieldHint,
                )
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const ShapeDecoration(
                color: AppColors.pureWhite,
                shape: CircleBorder(),
              ),
              child: Icon(
                expenseIcon(expenses['category']),
                color: AppColors.thatBrown.withOpacity(0.9),
              ),
            ),
            gapW12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'K${expenses['amount']}',
                  fontWeight: FontWeight.bold,
                ),
                TextWidget(
                  text: expenses['category'],
                  color: AppColors.textFieldHint,
                ),
              ],
            ),
            Spacer(),
            TextWidget(text: formattedDate),
          ],
        ),
      ),
    );
  }
}
