import 'package:flutter/material.dart';

IconData paymentTypeIcon(int paymentType) {
  IconData icon = Icons.abc;

  switch (paymentType) {
    case 1:
      icon = Icons.money_rounded;
      break;
    case 2:
      icon = Icons.credit_card_rounded;
      break;
    case 3:
      icon = Icons.attach_money_rounded;
      break;
  }
  return icon;
}
