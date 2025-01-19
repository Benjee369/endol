import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../common/text_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../function/expense_icon.dart';
import 'custom_popup_menu.dart';

class ExpenseDetailsDialog extends StatelessWidget {
  const ExpenseDetailsDialog({
    super.key,
    required this.expenses,
    required this.deleteFunction,
    required this.formattedDate,
  });

  final Map<String, dynamic> expenses;
  final VoidCallback deleteFunction;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            onSelected: (value) {
              switch (value) {
                case 0:
                  log('Update pressed');
                  break;
                case 1:
                  deleteFunction.call();
                  break;
              }
            },
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
          expenses['description'] != null
              ? Column(
                  children: [
                    gapH12,
                    TextWidget(text: expenses['description']),
                  ],
                )
              : SizedBox(),
          gapH12,
          TextWidget(
            text: formattedDate,
            color: AppColors.textFieldHint,
          )
        ],
      ),
    );
  }
}
