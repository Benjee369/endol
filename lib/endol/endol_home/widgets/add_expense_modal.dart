import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/endol/endol_home/widgets/payment_type_radio_list.dart';
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
  final VoidCallback initializeFunction;

  const AddExpenseModal({
    super.key,
    required this.initializeFunction,
  });

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String? categoryValue;
  DateTime? selectedDate = DateTime.now();
  late TextEditingController dateController;
  bool isLoading = false;
  int _value = 1;

  //connection to database
  final storageRef = FirebaseStorage.instance.ref();
  CollectionReference data = FirebaseFirestore.instance.collection(
    Strings.expenseDatabase,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;

  // List of items in the category selector
  final List<Map> categories = [
    {
      'name': 'Food',
      'icon': Icons.fastfood_rounded,
    },
    {
      'name': 'Rent',
      'icon': Icons.home_rounded,
    },
    {
      'name': 'Transport',
      'icon': Icons.directions_bus_rounded,
    },
    {
      'name': 'Misc',
      'icon': Icons.miscellaneous_services_rounded,
    },
    {
      'name': 'School Fees',
      'icon': Icons.school_rounded,
    },
    {
      'name': 'Subscriptions',
      'icon': Icons.subscriptions_rounded,
    },
    {
      'name': 'Luxury',
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'name': 'Eating Out',
      'icon': Icons.restaurant_rounded,
    },
  ];

  //Function that adds details to database
  Future<void> _addDetails() async {
    setState(() {
      isLoading = true;
    });
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try {
      if (amountController.text.isEmpty || categoryValue!.isEmpty) {
        Dialogs.dialogInform(context, 'Please enter all details', () {
          Navigator.pop(context);
        }, Strings.ok);
      } else {
        double value = double.parse(amountController.text);

        log(
          'uid: $uid,\n'
          'category: $categoryValue,\n'
          'amount: $value,\n'
          'expenseDate: $selectedDate, \n'
          'description: ${descriptionController.text},\n'
          'payment_type: $_value',
        );

        data.add({
          'uid': uid,
          'category': categoryValue,
          'amount': value,
          'expenseDate': selectedDate,
          'description': descriptionController.text,
          'payment_type': _value,
          'currentDate': DateTime.now()
        });
        Navigator.pop(context);
        widget.initializeFunction.call();
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
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 150,
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    isExpanded: true,
                    hint: const TextWidget(
                      text: ' Select Category',
                      size: 14,
                      color: AppColors.textFieldHint,
                    ),
                    items: categories
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item['name'],
                            child: Row(
                              children: [
                                Icon(
                                  item['icon'],
                                  color: AppColors.thatBrown,
                                  size: 20,
                                ),
                                gapW8,
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
                  hint: 'Description (Optional)',
                  controller: descriptionController,
                  inputType: TextInputType.text,
                  isReadOnly: false,
                ),
                gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PaymentTypeRadioList<int>(
                      value: 1,
                      groupValue: _value,
                      leading: 'Cash',
                      // title: Text('One'),
                      icon: Icons.money_rounded,
                      onChanged: (value) => setState(() => _value = value!),
                    ),
                    PaymentTypeRadioList<int>(
                      value: 2,
                      groupValue: _value,
                      leading: 'Card',
                      // title: Text('Two'),
                      icon: Icons.credit_card_rounded,
                      onChanged: (value) => setState(() => _value = value!),
                    ),
                    PaymentTypeRadioList<int>(
                      value: 3,
                      groupValue: _value,
                      leading: 'Mobile Money',
                      icon: Icons.attach_money_rounded,
                      // title: Text('Two'),
                      onChanged: (value) => setState(() => _value = value!),
                    ),
                  ],
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
                  isLoading: isLoading,
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
