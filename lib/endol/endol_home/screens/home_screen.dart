import 'dart:developer';
import 'package:endol/common/custom_app_bar.dart';
import 'package:endol/common/dialogs.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../constants/strings.dart';
import '../../../providers/budget_provider.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/home_amount_widget.dart';
import '../widgets/recent_transaction_widget.dart';

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
  double totalSpent = 0.0;
  double budgetLeft = 0.0;
  double? budgetAmount;
  List<Map<String, dynamic>> expenseData = [];

  //database connections
  CollectionReference data = FirebaseFirestore.instance.collection(
    Strings.expenseDatabase,
  );
  final storageRef = FirebaseFirestore.instance.collection(
    Strings.budgetDatabase,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future initialise() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      await getTotalSpent();
      await getBudget();
      getBudgetLeft();
    } catch (e) {
      log('$e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> getBudget() async {
    try {
      final budgetProvider =
          Provider.of<BudgetProvider>(context, listen: false);
      final amount = budgetProvider.budgetAmount;

      log('${user?.email}');
      if (amount != null) {
        budgetAmount = amount;
      } else {
        var data = await storageRef.doc(user?.uid).get();
        if (data.exists) {
          budgetAmount = data['budget'];
          if (mounted) {
            Provider.of<BudgetProvider>(context, listen: false)
                .setBudget(budgetAmount!);
          }
        }
      }
      getBudgetLeft();

      log('this is the budget amount: $budgetAmount');
    } catch (e) {
      log('$e');
    }
  }

  Future getBudgetLeft() async {
    budgetLeft = (budgetAmount ?? 0.0) - totalSpent;
    log('this is the budget left: $budgetLeft');
  }

  Future<double> getTotalSpent() async {
    totalSpent = 0.0;

    try {
      QuerySnapshot querySnapshot = await data
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('currentDate', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        double value = doc['amount'];
        totalSpent += value;
      }
      if (querySnapshot.docs.isNotEmpty) {
        expenseData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      log('$e');
    }
    log('This is the total spent: $totalSpent');
    return totalSpent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: const CustomAppBar(title: 'Home'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(
              //   width: double.infinity,
              //   height: 200,
              //   child: ExtendedImage.asset(
              //     'assets/images/home_background_image.png',
              //     scale: 2,
              //     fit: BoxFit.fitWidth,
              //   ),
              // ),
              gapH12,
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeAmountWidget(
                      title: Strings.totalSpent,
                      amount: '$totalSpent',
                      isLoading: isLoading,
                    ),
                    gapW12,
                    HomeAmountWidget(
                      title: Strings.budgetLeft,
                      amount: '$budgetLeft',
                      isLoading: isLoading,
                      textColor: budgetLeft < 0 ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ),
              gapH24,
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
                          color: AppColors.thatBrown,
                          fontWeight: FontWeight.bold,
                          size: 19,
                        ),
                        TextWidget(
                          text: Strings.startTracking,
                          color: AppColors.lightBrown,
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

              gapH24,
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    text: 'Recent Transactions',
                    color: AppColors.thatBrown,
                    fontWeight: FontWeight.bold,
                    size: 19,
                  ),
                ),
              ),
              gapH12,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isLoading
                    ? Dialogs.loadingInScreen()
                    : RefreshIndicator(
                        onRefresh: initialise,
                        color: AppColors.thatBrown,
                        backgroundColor: AppColors.pureWhite,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount:
                              expenseData.length < 5 ? expenseData.length : 5,
                          itemBuilder: (context, index) {
                            final expenses = expenseData[index];

                            DateTime dateTime =
                                expenses['expenseDate'].toDate();

                            DateTime now = DateTime.now();
                            DateTime today =
                                DateTime(now.year, now.month, now.day);

                            DateTime orderDateMidnight = DateTime(
                                dateTime.year, dateTime.month, dateTime.day);
                            String formattedDate;

                            if (orderDateMidnight == today) {
                              formattedDate =
                                  "Today at ${DateFormat('hh:mm a').format(dateTime)}";
                            } else {
                              formattedDate =
                                  DateFormat('MMM dd, yyyy').format(dateTime);
                            }
                            return RecentTransactionWidget(
                              expenses: expenses,
                              formattedDate: formattedDate,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return gapH12;
                          },
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
