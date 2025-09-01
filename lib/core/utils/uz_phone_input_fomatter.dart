import 'package:flutter/services.dart';

class UzPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Remove leading country code if user tries to input it again
    if (digits.startsWith('998')) {
      digits = digits.substring(3);
    }

    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    final buffer = StringBuffer('+998(');
    if (digits.isNotEmpty) {
      if (digits.length >= 2) {
        buffer.write(digits.substring(0, 2));
        buffer.write(')');
        if (digits.length > 2) {
          buffer.write(' ');
          if (digits.length >= 5) {
            buffer.write(digits.substring(2, 5));
            if (digits.length > 5) {
              buffer.write(' ');
              if (digits.length >= 7) {
                buffer.write(digits.substring(5, 7));
                if (digits.length > 7) {
                  buffer.write(' ');
                  buffer.write(digits.substring(7));
                }
              } else {
                buffer.write(digits.substring(5));
              }
            } else {
              buffer.write(digits.substring(2));
            }
          } else {
            buffer.write(digits.substring(2));
          }
        }
      } else {
        buffer.write(digits);
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
