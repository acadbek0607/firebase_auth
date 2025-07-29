import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
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
      padding: const EdgeInsets.fromLTRB(16.0, 0, 24.0, 0),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.cardGrey),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value!.isNotEmpty ? value : null,
        onChanged: onChanged,
        decoration: const InputDecoration(border: InputBorder.none),
        dropdownColor: AppColors.dark,
        icon: SvgPicture.asset('assets/svg/drop_down.svg'),
        iconEnabledColor: AppColors.cardGrey,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _capitalize(item),
                      style: Kstyle.textStyle.copyWith(
                        color: AppColors.cardWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? AppColors.lightGreen
                        : AppColors.cardGrey,
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
    if (s.contains(' ')) return s;
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
