import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends StatelessWidget {
  final ValueNotifier<List<String>> _selectedEvents = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2022, 01, 01),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
        // Add logic to highlight selected day
        return false; // For now, none are selected
      },
      onDaySelected: (selectedDay, focusedDay) {
        // Set the selected day and update events for that day
        _selectedEvents.value = _getEventsForDay(selectedDay);
      },
      eventLoader: _getEventsForDay,
      calendarStyle: CalendarStyle(
        // Customize calendar appearance
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Mock data: Example of events based on a specific day
  List<String> _getEventsForDay(DateTime day) {
    if (day.day == 1) {
      return ['Event 1', 'Event 2'];
    }
    if (day.day == 15) {
      return ['Event 3'];
    }
    return [];
  }
}
