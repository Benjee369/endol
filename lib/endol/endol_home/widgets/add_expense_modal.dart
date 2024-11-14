import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../common/button_primary.dart';
import '../../../common/dialogs.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/strings.dart';
import 'package:intl/intl.dart';

import 'add_expense_text_field.dart';

class AddExpenseModal extends StatefulWidget {
  const AddExpenseModal({super.key});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final amountController = TextEditingController();
  String? categoryValue;
  DateTime? selectedDate = DateTime.now();
  late TextEditingController dateController;
  bool isLoading = false;

  //connection to database
  final storageRef = FirebaseStorage.instance.ref();
  CollectionReference data = FirebaseFirestore.instance.collection(
    Strings.expenseDatabase,
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

  //Function that adds details to database
  Future<void> _addDetails() async {
    setState(() {
      isLoading = true;
    });
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try {
      if (amountController.text.isEmpty) {
        Dialogs.dialogInform(context, 'Please enter details', () {
          Navigator.pop(context);
        }, Strings.ok);
      } else {
        data.add({
          'uid': uid,
          'category': categoryValue,
          'amount': amountController.text,
          'expenseDate': selectedDate,
          'currentDate': DateTime.now()
        });
      }
    } catch (e) {
      log('$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //Function that displays the date selector on the screen
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    setState(() {
      selectedDate = picked;
      log('$selectedDate-----------------------');
      dateController.text = DateFormat('yyyy/MM/dd').format(selectedDate!);
    });
  }

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(selectedDate!),
    );
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
                    text: Strings.addNewExpense,
                    fontWeight: FontWeight.bold,
                    size: 20,
                  ),
                ),
                gapH20,
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
                  isReadOnly: false,
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
                    value: categoryValue,
                    onChanged: (String? value) {
                      setState(() {
                        categoryValue = value;
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
                      ),
                    ),
                  ),
                ),
                gapH12,
                AddExpenseTextField(
                  hint: 'Date',
                  controller: dateController,
                  inputType: TextInputType.text,
                  datePicker: true,
                  dateFunction: () {
                    _selectDate(context);
                  },
                  isReadOnly: true,
                ),
                // CalendarDatePicker2(
                //   config: CalendarDatePicker2Config(),
                //   value: _dates,
                //   onValueChanged: (dates) => _dates = dates,
                // ),
                gapH32,
                ButtonPrimary(
                  active: true,
                  height: 50,
                  color: AppColors.thatBrown,
                  text: 'SAVE',
                  function: () {
                    _addDetails();
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
