import 'package:flutter/material.dart';

class BudgetProvider with ChangeNotifier {
  double? budgetAmount;

  void setBudget(double amount) {
    budgetAmount = amount;
  }
}
