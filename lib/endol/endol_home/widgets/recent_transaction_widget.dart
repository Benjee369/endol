import 'package:endol/endol/endol_home/function/expense_payment_type_icon.dart';
import 'package:flutter/material.dart';
import '../../../common/text_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../function/expense_icon.dart';
import 'expense_details_dialog.dart';

class RecentTransactionWidget extends StatelessWidget {
  const RecentTransactionWidget({
    super.key,
    required this.expenses,
    required this.formattedDate,
    required this.deleteFunction,
  });

  final Map<String, dynamic> expenses;
  final String formattedDate;
  final VoidCallback deleteFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => ExpenseDetailsDialog(
            expenses: expenses,
            deleteFunction: deleteFunction,
            formattedDate: formattedDate,
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const ShapeDecoration(
                color: AppColors.pureWhite,
                shape: CircleBorder(),
              ),
              child: Icon(
                expenseIcon(expenses['category']),
                color: AppColors.thatBrown.withOpacity(0.8),
                size: 30,
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
            Column(
              children: [
                expenses['payment_type'] != null
                    ? Icon(
                        paymentTypeIcon(
                          expenses['payment_type'],
                        ),
                        color: AppColors.thatBrown.withOpacity(0.8),
                      )
                    : SizedBox(),
                TextWidget(
                  text: formattedDate,
                  size: 14,
                  color: AppColors.textFieldHint,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
