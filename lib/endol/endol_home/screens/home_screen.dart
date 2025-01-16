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

  //Function that is used to call all the functions to initialise the data
  Future initialise() async {
    log('Initialize function triggered');

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

  //function to get the budget
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

  //Function to calculate the remaining budget
  Future getBudgetLeft() async {
    budgetLeft = (budgetAmount ?? 0.0) - totalSpent;
    log('this is the budget left: $budgetLeft');
  }

  //Function to get all the documents and calculate the total spent
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
        expenseData = querySnapshot.docs.map((doc) {
          Map<String, dynamic> expense = doc.data() as Map<String, dynamic>;
          expense['id'] = doc.id;
          return expense;
        }).toList();
        // log('${expenseData[0].}');
      } else {
        expenseData = [];
      }
    } catch (e) {
      log('$e');
    }
    log('This is the total spent: $totalSpent');
    return totalSpent;
  }

  //Function to delete a transaction
  Future deleteTransaction(String id) async {
    log('Delete function triggered');

    await data.doc(id).delete().then(
          (_) => log('Document $id deleted'),
        );
    initialise();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: CustomAppBar(
          title: 'Home',
          isRefreshOn: true,
          refresh: () {
            initialise();
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                        builder: (context) => AddExpenseModal(
                          initializeFunction: () {
                            initialise();
                          },
                        ),
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
                    : expenseData.isEmpty
                        ? TextWidget(text: 'No Expenses')
                        : RefreshIndicator(
                            onRefresh: initialise,
                            color: AppColors.thatBrown,
                            backgroundColor: AppColors.pureWhite,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: expenseData.length < 5
                                  ? expenseData.length
                                  : 5,
                              itemBuilder: (context, index) {
                                final expenses = expenseData[index];

                                log('${expenses['id']}');
                                DateTime dateTime =
                                    expenses['expenseDate'].toDate();

                                DateTime now = DateTime.now();
                                DateTime today =
                                    DateTime(now.year, now.month, now.day);

                                DateTime orderDateMidnight = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day);
                                String formattedDate;

                                if (orderDateMidnight == today) {
                                  formattedDate =
                                      "Today at ${DateFormat('hh:mm a').format(dateTime)}";
                                } else {
                                  formattedDate = DateFormat('MMM dd, yyyy')
                                      .format(dateTime);
                                }
                                return RecentTransactionWidget(
                                  expenses: expenses,
                                  formattedDate: formattedDate,
                                  deleteFunction: () {
                                    deleteTransaction(expenses['id']);
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
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
