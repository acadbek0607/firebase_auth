import 'package:fire_auth/core/constants/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const CustomCheckboxTile({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected ? 'assets/svg/s_check.svg' : 'assets/svg/check.svg',
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Kstyle.textStyle.copyWith(
              color: isSelected ? Color(0xFFF2F2F2) : Color(0xFFA6A6A6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
