import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:flutter_svg/svg.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDaySelected;

  const CalendarWidget({super.key, this.initialDate, this.onDaySelected});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedWeekStart;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate;
    _focusedWeekStart = _getMonday(_selectedDay ?? DateTime.now());
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

      widget.onDaySelected?.call(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getVisibleWeekDays();

    final dayLabels = [
      tr('day_monday', context: context),
      tr('day_tuesday', context: context),
      tr('day_wednesday', context: context),
      tr('day_thursday', context: context),
      tr('day_friday', context: context),
      tr('day_saturday', context: context),
      tr('day_sunday', context: context),
    ];
    final monthLabels = [
      '',
      tr('month_january', context: context),
      tr('month_february', context: context),
      tr('month_march', context: context),
      tr('month_april', context: context),
      tr('month_may', context: context),
      tr('month_june', context: context),
      tr('month_july', context: context),
      tr('month_august', context: context),
      tr('month_september', context: context),
      tr('month_october', context: context),
      tr('month_november', context: context),
      tr('month_december', context: context),
    ];

    final weekRow = Row(
      key: ValueKey(_focusedWeekStart.toIso8601String()),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((day) {
        final isSelected =
            _selectedDay != null && _isSameDay(day, _selectedDay!);
        return GestureDetector(
          onTap: () => _selectDay(day),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 12.0,
            ),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(6),
                  )
                : null,
            child: Column(
              children: [
                Text(
                  dayLabels[day.weekday - 1],
                  style: Kstyle.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: Kstyle.textStyle.copyWith(
                    color: isSelected ? Colors.white : Color(0xFF999999),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 1,
                  width: 20,
                  color: isSelected ? Colors.white : Color(0xFF999999),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: const Color(0xFF1E1E20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  '${monthLabels[_focusedWeekStart.month]}, ${_focusedWeekStart.year}',
                  style: Kstyle.textStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _goToPreviousWeek,
                    icon: SvgPicture.asset('assets/svg/left.svg', height: 32.0),
                    color: const Color(0xFFD1D1D1),
                  ),
                  IconButton(
                    onPressed: _goToNextWeek,
                    icon: SvgPicture.asset(
                      'assets/svg/right.svg',
                      height: 32.0,
                    ),
                    color: const Color(0xFFD1D1D1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
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
