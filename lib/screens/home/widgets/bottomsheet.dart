import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/screens/home/widgets/add_expense_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../common/button_primary.dart';
import '../../../common/dialogs.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/strings.dart';

class ModalFit extends StatefulWidget {
  const ModalFit({super.key});

  @override
  State<ModalFit> createState() => _ModalFitState();
}

class _ModalFitState extends State<ModalFit> {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  String? selectedValue;

  final storageRef = FirebaseStorage.instance.ref();
  CollectionReference data = FirebaseFirestore.instance.collection(
    'expensedetails',
  );
  final FirebaseAuth auth = FirebaseAuth.instance;

  // List of items in the category selector
  final List<String> category = [
    'Food',
    'Rent',
    'Transport',
    'Misc',
    'School Fees',
    'Subscriptions',
    'Luxury',
    'Eating Out'
  ];

  Future<void> addDetails() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try {
      if (categoryController.text.isEmpty || amountController.text.isEmpty) {
        Dialogs.dialogInform(context, 'Please enter details', () {
          Navigator.pop(context);
        }, Strings.ok);
      } else {
        data.add({
          'uid': uid,
          'category': categoryController.text,
          'amount': amountController.text,
        });
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          // This ensures the modal moves up when the keyboard is open.
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
                gapH12,
                const TextWidget(
                  text: 'Add Expense',
                  fontWeight: FontWeight.bold,
                ),
                gapH16,
                AddExpenseTextField(
                  hint: 'Amount',
                  controller: amountController,
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
                ),
                gapH12,
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 150,
                      decoration: BoxDecoration(color: AppColors.pureWhite),
                    ),
                    isExpanded: true,
                    hint: const TextWidget(
                      text: ' Select Item',
                      size: 14,
                      color: AppColors.textFieldHint,
                    ),
                    items: category
                        .map(
                          (String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.pureWhite,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 65,
                      width: double.infinity,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    iconStyleData: const IconStyleData(
                        icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textFieldHint,
                      size: 30,
                    )),
                  ),
                ),
                gapH12,
                AddExpenseTextField(
                  hint: 'Date',
                  controller: dateController,
                  inputType: TextInputType.text,
                ),
                gapH32,
                ButtonPrimary(
                  active: true,
                  height: 50,
                  width: 180,
                  color: AppColors.thatBrown,
                  text: 'SAVE',
                  function: () {},
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
