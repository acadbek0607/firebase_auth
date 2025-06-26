import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<DateTime> _getVisibleWeekDay(DateTime focusedDay) {
    final startOfWeek = focusedDay.subtract(
      Duration(days: focusedDay.weekday - 1),
    );
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  void _goToPreviousWeek() {
    setState(() {
      _focusedDay = _focusedDay.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _focusedDay = _focusedDay.add(const Duration(days: 7));
    });
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getVisibleWeekDay(_focusedDay);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // Month title and arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMMM().format(_focusedDay),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFDADADA),
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

          // Weekdays row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              final isSelected = isSameDay(day, _selectedDay);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                    _focusedDay = day.subtract(Duration(days: day.weekday - 1));
                  });
                },
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.day}',
                        style: const TextStyle(color: Color(0xFFD1D1D1)),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: 20,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
