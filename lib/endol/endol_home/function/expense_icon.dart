import 'package:flutter/material.dart';

IconData expenseIcon(String expenseType) {
  IconData icon = Icons.abc;

  switch (expenseType) {
    case "Food":
      icon = Icons.fastfood_rounded;
      break;
    case "Rent":
      icon = Icons.home_rounded;
      break;
    case "Transport":
      icon = Icons.directions_bus_rounded;
      break;
    case "Misc":
      icon = Icons.category_rounded;
      break;
    case "School Fees":
      icon = Icons.school_rounded;
      break;
    case "Subscriptions":
      icon = Icons.subscriptions_rounded;
      break;
    case "Luxury":
      icon = Icons.style_rounded;
      break;
    case "Eating Out":
      icon = Icons.restaurant_rounded;
      break;
    default:
      icon = Icons.help_rounded;
      break;
  }

  return icon;
}
