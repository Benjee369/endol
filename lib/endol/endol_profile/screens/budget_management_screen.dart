import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/button_primary.dart';
import 'package:endol/common/custom_app_bar.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_sizes.dart';
import 'package:endol/providers/budget_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../constants/strings.dart';
import '../widget/edit_budget_bottom_sheet.dart';

class BudgetManagementScreen extends StatefulWidget {
  const BudgetManagementScreen({super.key});

  @override
  State<BudgetManagementScreen> createState() => _BudgetManagementScreenState();
}

class _BudgetManagementScreenState extends State<BudgetManagementScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  double? budgetAmount;
  bool budgetIsLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBudget();
  }

  //connection to database
  final storageRef = FirebaseFirestore.instance.collection(
    Strings.budgetDatabase,
  );

  Future<void> getBudget() async {
    // if (mounted) {
    //   setState(() {
    //     budgetIsLoading = true;
    //   });
    // }

    try {
      final budgetProvider =
          Provider.of<BudgetProvider>(context, listen: false);
      final amount = budgetProvider.budgetAmount;

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
    } catch (e) {
      log('$e');
    } finally {
      // if (mounted) {
      //   setState(() {
      //     budgetIsLoading = false;
      //   });
      // }
    }
  }

  Future<void> getBudgetAfterUpdate() async {
    // if (mounted) {
    //   setState(() {
    //     budgetIsLoading = true;
    //   });
    // }

    try {
      var data = await storageRef.doc(user?.uid).get();
      if (data.exists) {
        setState(() {
          budgetAmount = data['budget'];
        });
        if (mounted) {
          Provider.of<BudgetProvider>(context, listen: false)
              .setBudget(budgetAmount!);
        }
      }
    } catch (e) {
      log('$e');
    } finally {
      // if (mounted) {
      //   setState(() {
      //     budgetIsLoading = false;
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Budget'),
      body: Center(
        child: Column(
          children: [
            gapH48,
            budgetIsLoading
                ? const CircularProgressIndicator()
                : TextWidget(
                    text: budgetAmount == null ? 'K 0' : 'K $budgetAmount',
                    fontWeight: FontWeight.bold,
                    size: 30,
                  ),
            gapH24,
            ButtonPrimary(
              width: size.width * 0.6,
              text: 'Edit Budget',
              function: () => showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => EditBudgetBottomSheet(
                  getBudgetTrigger: getBudgetAfterUpdate(),
                ),
              ),
              active: true,
            )
          ],
        ),
      ),
    );
  }
}
