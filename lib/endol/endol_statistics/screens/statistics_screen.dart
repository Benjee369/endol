import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/custom_app_bar.dart';
import 'package:endol/common/dialogs.dart';
import 'package:endol/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../../common/text_widget.dart';
import '../../../constants/app_colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  List<Map<String, dynamic>> expenseData = [];
  late Map<String, double> categoryTotals;

  final storageRef =
      FirebaseFirestore.instance.collection(Strings.expenseDatabase);

  //Function to group docs by category and sum up the amounts
  Map<String, double> groupExpenses(List<Map<String, dynamic>> expenses) {
    return expenses.groupFoldBy(
      (expense) => expense['category'] as String,
      (double? previousTotal, expense) =>
          (previousTotal ?? 0) + expense['amount'],
    );
  }

  //Function to get user expenses
  Future<void> _getUserExpenses() async {
    log('Get expense function triggered');
    final User? user = auth.currentUser;
    final uid = user?.uid;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      QuerySnapshot querySnapshot =
          await storageRef.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        expenseData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        categoryTotals = groupExpenses(expenseData);

        log('$categoryTotals');
        final double total = categoryTotals.values.reduce((a, b) => a + b);
        log('The total is $total');
      } else {
        log('Collection is empty ');
      }
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

  @override
  void initState() {
    super.initState();
    _getUserExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Statistics'),
      body: isLoading
          ? Dialogs.loadingInScreen()
          : SafeArea(
              child: Column(
                children: [
                  TextWidget(text: 'Expenses'),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: PieChart(
                      PieChartData(
                        sections: getSections(categoryTotals),
                        centerSpaceRadius: 20,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<PieChartSectionData> getSections(Map<String, double> data) {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      AppColors.thatBrown,
      Colors.green,
    ];
    // final double total = categoryTotals.values.reduce((a, b) => a + b);

    return data.entries.map((entry) {
      final int index = data.keys.toList().indexOf(entry.key);
      // final double percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        value: entry.value,
        color: colors[index % colors.length],
        title: entry.key,
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.pureWhite,
        ),
      );
    }).toList();
  }
}
