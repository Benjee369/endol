import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../common/button_primary.dart';
import '../../../common/dialogs.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/strings.dart';
import '../../endol_home/widgets/add_expense_text_field.dart';

class EditBudgetBottomSheet extends StatefulWidget {
  final Future getBudgetTrigger;

  const EditBudgetBottomSheet({
    super.key,
    required this.getBudgetTrigger,
  });

  @override
  State<EditBudgetBottomSheet> createState() => _EditBudgetBottomSheetState();
}

class _EditBudgetBottomSheetState extends State<EditBudgetBottomSheet> {
  final budgetAmountController = TextEditingController();
  String? categoryValue;
  DateTime? selectedDate = DateTime.now();
  bool isLoading = false;

  //connection to database
  final storageRef = FirebaseFirestore.instance.collection(
    Strings.budgetDatabase,
  );

  // //get current user
  // final FirebaseAuth auth = FirebaseAuth.instance;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<void> editBudget() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    if (budgetAmountController.text.isEmpty) {
      Dialogs.dialogInform(
        context,
        'Please enter details',
        () {
          Navigator.pop(context);
        },
        Strings.ok,
      );
      return;
    }

    try {
      double value = double.parse(budgetAmountController.text);

      await storageRef.doc(user?.uid).set(
        {
          'uid': user?.uid,
          'budget': value,
          'update_date': DateTime.now(),
        },
      );

      if (mounted) {
        Dialogs.dialogInform(
          context,
          'Budget updated successfully',
          () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          Strings.ok,
        );
        widget.getBudgetTrigger;
      }
    } catch (e) {
      log('Error updating budget: $e');
      if (mounted) {
        Dialogs.dialogInform(
          context,
          'Failed to update budget. Try again.',
          () {
            Navigator.pop(context);
          },
          Strings.ok,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 0,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
            decoration: const BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                gapH20,
                const Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    text: 'Edit Budget',
                    fontWeight: FontWeight.bold,
                    size: 20,
                  ),
                ),
                gapH20,
                AddExpenseTextField(
                  hint: 'Amount',
                  controller: budgetAmountController,
                  inputType: TextInputType.number,
                  prefixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        text: '     MWK  ',
                        size: 14,
                        color: AppColors.textFieldHint,
                      ),
                    ],
                  ),
                  isReadOnly: false,
                ),
                gapH12,
                gapH12,
                gapH32,
                ButtonPrimary(
                  isLoading: isLoading,
                  active: true,
                  height: 50,
                  color: AppColors.thatBrown,
                  text: 'SAVE',
                  function: () {
                    editBudget();
                  },
                ),
                gapH12,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
