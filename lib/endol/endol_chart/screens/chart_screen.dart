import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/custom_app_bar.dart';
import 'package:endol/common/dialogs.dart';
import 'package:endol/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

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

  // final userData = FirebaseFirestore.instance
  //     .collection(Strings.expenseDatabase)
  //     .doc(FirebaseAuth.instance.currentUser?.uid);

  //Function to group docs by category and sum up the amounts
  Map<String, double> groupExpenses(List<Map<String, dynamic>> expenses) {
    return expenses.groupFoldBy(
      (expense) => expense['category'] as String,
      (double? previousTotal, expense) =>
          (previousTotal ?? 0) + expense['amount'],
    );
  }

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
      // log('The expense data: $querySnapshot');

      if (querySnapshot.docs.isNotEmpty) {
        expenseData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        categoryTotals = groupExpenses(expenseData);
        // = groupExpenses(expenseData);

        log('$categoryTotals');
        // log('${categoryTotals.runtimeType}');
        final double total = categoryTotals.values.reduce((a, b) => a + b);
        log('The total is $total');
        //
        // categoryTotals.forEach((category, total) {
        //   log('$category: \$${total.toStringAsFixed(2)}');
        // });

        // for (var doc in querySnapshot.docs) {
        //   expenseData = doc.data() as Map<String, dynamic>;
        //   log('Category ${expenseData?['category']}, Amount${expenseData?['amount']}');
        //   log('${expenseData?.length}');
        // }
        // for (var expense in expenseData) {
        //   var data = expenseData
        //       .where((element) => element['category'] == expense['category']);
        //   if (data.isEmpty) {
        //     expenseData.add(expense);
        //   } else {
        //     log('${data.runtimeType}');
        //   }
        // }
        // log('${expenseData[1]['uid']}');
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
      appBar: CustomAppBar(title: 'Charts'),
      body:
          // ButtonPrimary(
          //     active: true,
          //     width: 200,
          //     text: 'Test',
          //     function: () {
          //       _getUserExpenses();
          //     }),
          isLoading
              ? Dialogs.loadingInScreen()
              : SafeArea(
                  child: PieChart(
                    PieChartData(
                      sections: getSections(categoryTotals),
                      centerSpaceRadius: 50,
                      sectionsSpace: 2,
                    ),
                  ),
                  // child: StreamBuilder<QuerySnapshot>(
                  //   stream: storageRef.snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const CircularProgressIndicator();
                  //     }
                  //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  //       return const TextWidget(text: 'Empty');
                  //     }
                  //     return ListView(
                  //       children: snapshot.data!.docs.map((doc) {
                  //         final expense = doc.data() as Map<String, dynamic>;
                  //         DateTime dateTime = expense['expenseDate'].toDate();
                  //         String formattedDate =
                  //             DateFormat('MM, dd, yyyy').format(dateTime);
                  //
                  //         log('$dateTime');
                  //         return Row(
                  //           children: [
                  //             const Icon(Icons.abc),
                  //             Column(
                  //               children: [
                  //                 TextWidget(text: expense['category']),
                  //                 TextWidget(text: formattedDate)
                  //               ],
                  //             )
                  //           ],
                  //         );
                  //         //   ListTile(
                  //         //   title: Text(expense['category']),
                  //         //   subtitle: Text('Amount: ${expense['amount']}'),
                  //         // );
                  //       }).toList(),
                  //     );
                  //   },
                  // ),
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.pureWhite,
        ),
      );
    }).toList();
  }
}
