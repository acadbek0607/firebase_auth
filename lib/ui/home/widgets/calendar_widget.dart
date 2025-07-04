import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fire_auth/core/constants/classes.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDaySelected;

  const CalendarWidget({super.key, this.initialDate, this.onDaySelected});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedWeekStart;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate ?? DateTime.now();
    _focusedWeekStart = _getMonday(_selectedDay);
  }

  DateTime _getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> _getVisibleWeekDays() {
    return List.generate(
      6, // Monday to Saturday
      (index) => _focusedWeekStart.add(Duration(days: index)),
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      _focusedWeekStart = _focusedWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _focusedWeekStart = _focusedWeekStart.add(const Duration(days: 7));
    });
  }

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDay = day;

      final startOfNewWeek = _getMonday(day);
      if (!_isSameDay(startOfNewWeek, _focusedWeekStart)) {
        _focusedWeekStart = startOfNewWeek;
      }

      // widget.onDaySelected?.call(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getVisibleWeekDays();

    final weekRow = Row(
      key: ValueKey(_focusedWeekStart.toIso8601String()),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        final isSelected = _isSameDay(day, _selectedDay);
        return GestureDetector(
          onTap: () => _selectDay(day),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10.0,
            ),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Column(
              children: [
                Text(
                  DateFormat.E().format(day),
                  style: Kstyle.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFFdadada),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: Kstyle.textStyle.copyWith(
                    color: isSelected ? Colors.white : const Color(0xFFdadada),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 1,
                  width: 20,
                  color: isSelected ? Colors.white : const Color(0xFFdadada),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: const Color(0xFF2C2C2E),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMMM().format(_focusedWeekStart),
                style: Kstyle.textStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _goToPreviousWeek,
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: const Color(0xFFdadada),
                  ),
                  IconButton(
                    onPressed: _goToNextWeek,
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: const Color(0xFFdadada),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: weekRow,
          ),
        ],
      ),
    );
  }
}
