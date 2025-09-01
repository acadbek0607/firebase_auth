import 'package:flutter/services.dart';

class UzPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final isDeleting = oldValue.text.length > newValue.text.length;

    // Raw digits from new value
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Always start with 998
    if (!digits.startsWith('998')) {
      digits = '998$digits';
    }

    // Limit to 12 digits total
    if (digits.length > 12) {
      digits = digits.substring(0, 12);
    }

    // Build formatted string
    String formatted = '+998';
    if (digits.length > 3) {
      formatted += '(${digits.substring(3, digits.length.clamp(3, 5))}';
    }
    if (digits.length >= 5) {
      formatted += ') ${digits.substring(5, digits.length.clamp(5, 8))}';
    }
    if (digits.length >= 8) {
      formatted += ' ${digits.substring(8, digits.length.clamp(8, 10))}';
    }
    if (digits.length >= 10) {
      formatted += ' ${digits.substring(10, digits.length.clamp(10, 12))}';
    }

    // Figure out new cursor position
    int cursorPos;
    if (isDeleting) {
      // If deleting a space or bracket, move cursor back one more
      final oldCursor = oldValue.selection.baseOffset;
      if (oldCursor > 0 &&
          RegExp(r'\D').hasMatch(oldValue.text[oldCursor - 1])) {
        cursorPos = oldCursor - 1;
      } else {
        cursorPos = newValue.selection.baseOffset;
      }
    } else {
      cursorPos = formatted.length;
    }

    // Clamp cursor position
    if (cursorPos > formatted.length) {
      cursorPos = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPos),
    );
  }
}
