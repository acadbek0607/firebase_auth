import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KFormat {
  static DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  static NumberFormat amountFormat = NumberFormat('#,##0', 'en_US');
  static String formatPhone(String phone) {
    // Remove non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 12 || !digits.startsWith('998')) return phone;

    final country = digits.substring(0, 3); // 998
    final operator = digits.substring(3, 5); // 97
    final part1 = digits.substring(5, 8); // 721
    final part2 = digits.substring(8, 10); // 06
    final part3 = digits.substring(10, 12); // 88

    return '+$country $operator $part1 $part2 $part3';
  }
}

class Kstyle {
  static ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(AppColors.darkGreen),
    foregroundColor: WidgetStateProperty.all<Color>(AppColors.buttonFor),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 12.0),
    ),
  );

  static TextStyle textStyle = TextStyle(
    fontFamily: 'Ubuntu',
    color: AppColors.cardWhite,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  static InputDecoration textFieldStyle = InputDecoration(
    labelStyle: TextStyle(color: AppColors.newLabel),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        width: 1.2,
        color: AppColors.newLabel.withAlpha(102),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(width: 1.2, color: AppColors.newLabel),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        width: 1.2,
        color: AppColors.newLabel.withAlpha(102),
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(width: 1.2, color: AppColors.newLabel),
    ),
    errorStyle: TextStyle(color: Colors.red),
  );
}
