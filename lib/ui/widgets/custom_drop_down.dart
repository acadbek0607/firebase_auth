import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 0.5, 24.0, 0.5),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value!.isNotEmpty ? value : null,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        dropdownColor: const Color(0xFF2B2B2B),
        icon: SvgPicture.asset('assets/svg/drop_down.svg'),
        iconEnabledColor: Colors.grey,
        selectedItemBuilder: (context) => items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _capitalize(item),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        items: items.map((item) {
          final isSelected = item == value;
          return DropdownMenuItem<String>(
            value: item,
            child: SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _capitalize(item),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? Colors.teal : Colors.grey,
                    size: 18,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) {
    return s
        .split('_')
        .map((word) {
          if (word.toLowerCase() == 'iq') return 'IQ';
          return word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '';
        })
        .join(' ');
  }
}
