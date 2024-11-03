import 'dart:developer';
import 'package:endol/common/dialogs.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/screens/home/widgets/add_expense_modal.dart';
import 'package:endol/screens/home/widgets/home_amount_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../constants/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../constants/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  bool isLoading = false;

  final storageRef = FirebaseStorage.instance.ref();
  CollectionReference data = FirebaseFirestore.instance.collection(
    Strings.expenseDatabase,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addDetails() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try {
      setState(() {
        isLoading = true;
      });
      if (categoryController.text.isEmpty || amountController.text.isEmpty) {
        Dialogs.dialogInform(context, 'Please enter a details', () {
          Navigator.pop(context);
        }, Strings.ok);
        setState(() {
          isLoading = false;
        });
      } else {
        data.add({
          'uid': uid,
          'category': categoryController.text,
          'amount': amountController.text,
        });
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.cream,
          title: const TextWidget(
            text: 'Home',
            color: AppColors.thatBrown,
            fontWeight: FontWeight.bold,
            size: 20,
          ),
        ),
        body: Column(
          children: [
            ExtendedImage.asset(
              'assets/images/home_background_image.png',
            ),
            gapH12,
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: Strings.addNewExpense,
                        fontWeight: FontWeight.bold,
                        color: AppColors.thatBrown,
                      ),
                      TextWidget(
                        text: Strings.startTracking,
                        color: AppColors.cream,
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () => showMaterialModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AddExpenseModal(),
                    ),
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.thatBrown,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.cream,
                      ),
                    ),
                  )
                ],
              ),
            ),
            gapH12,
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeAmountWidget(
                    title: Strings.totalSpent,
                    amount: '0.00',
                  ),
                  HomeAmountWidget(
                    title: Strings.budgetLeft,
                    amount: '0.00',
                  ),
                ],
              ),
            ),
            gapH12,
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: 'Recent Transactions',
                  color: AppColors.lightBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
