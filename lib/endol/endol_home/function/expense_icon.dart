import 'package:flutter/material.dart';

IconData expenseIcon(String expenseType) {
  IconData icon = Icons.abc;

  switch (expenseType) {
    case "Food":
      icon = Icons.fastfood;
      break;
    case "Luxury":
      icon = Icons.money;
      break;
    case "Transport":
      icon = Icons.emoji_transportation;
      break;
    case "Rent":
      icon = Icons.house;
      break;
    // case ""
  }
  return icon;
}
