/*import 'package:fire_auth/core/constants/app_colors.dart';
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
        borderRadius: BorderRadius.circular(4.0),
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
}*/

// CustomDropdown without animations, matching dropdown width to body
// Uses MenuAnchor on Android and CupertinoPicker on iOS

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';

class CustomDropdown extends StatefulWidget {
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
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoPicker(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return MenuAnchor(
          builder: (context, controller, child) => GestureDetector(
            onTap: () {
              setState(() => _menuOpen = !_menuOpen);
              _menuOpen ? controller.open() : controller.close();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.cardGrey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.value != null && widget.value!.isNotEmpty
                        ? _capitalize(widget.value!)
                        : widget.label,
                    style: Kstyle.textStyle.copyWith(color: Colors.white),
                  ),
                  SvgPicture.asset('assets/svg/drop_down.svg'),
                ],
              ),
            ),
          ),
          menuChildren: widget.items.map((item) {
            final isSelected = item == widget.value;
            return SizedBox(
              width: constraints.maxWidth,
              child: MenuItemButton(
                onPressed: () {
                  setState(() => _menuOpen = false);
                  widget.onChanged(item);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _capitalize(item),
                        style: Kstyle.textStyle.copyWith(
                          color: AppColors.cardWhite,
                        ),
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 18,
                      color: isSelected
                          ? AppColors.lightGreen
                          : AppColors.cardGrey,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCupertinoPicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCupertinoPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.cardGrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.value != null && widget.value!.isNotEmpty
                  ? _capitalize(widget.value!)
                  : widget.label,
              style: Kstyle.textStyle.copyWith(color: Colors.white),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: AppColors.dark,
        child: CupertinoPicker(
          backgroundColor: AppColors.dark,
          itemExtent: 40,
          scrollController: FixedExtentScrollController(
            initialItem: widget.items.indexOf(widget.value ?? ''),
          ),
          onSelectedItemChanged: (i) => widget.onChanged(widget.items[i]),
          children: widget.items
              .map(
                (item) => Center(
                  child: Text(_capitalize(item), style: Kstyle.textStyle),
                ),
              )
              .toList(),
        ),
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
