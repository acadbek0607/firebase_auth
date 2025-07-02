import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KDataFormat {
  static DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  static NumberFormat amountFormat = NumberFormat('#,##0', 'en_US');
}

class Kstyle {
  static ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF008F7F)),
    foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFDFDFD)),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)),
  );

  static TextStyle textStyle = TextStyle(color: Color(0xFFE7E7E7));

  static InputDecoration textFieldStyle = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        width: 1.2,
        color: Color(0xFFF1F1F1).withAlpha(102),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(width: 1.2, color: Color(0xFFF1F1F1)),
    ),
  );
}
