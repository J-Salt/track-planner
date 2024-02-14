import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_planner/create_workout.dart';
import 'package:track_planner/utils/reusable_appbar.dart';

final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class Calendar extends ConsumerWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();

    final selectedDay = ref.watch(selectedDayProvider);
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Calendar",
        context: context,
        trailingActions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateWorkout()))
                  },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: TableCalendar(
        firstDay: DateTime(
          now.year,
          now.month - 1,
        ),
        lastDay: DateTime(now.year, now.month + 2, 0),
        focusedDay: now,
        selectedDayPredicate: (day) {
          final selectedDay = ref.read(selectedDayProvider.notifier).state;
          return isSameDay(day, selectedDay);
        },
        onDaySelected: (selectedDay, focusedDay) {
          ref.read(selectedDayProvider.notifier).state = selectedDay;
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, date, _) {
            final isSelected = isSameDay(date, selectedDay);
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : null,
              ),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
