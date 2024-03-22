import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/create_workout.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/workout.dart';

final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class Calendar extends ConsumerStatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Workout>> workouts = {};
  final Service service = Service();
  final String uid = Auth().currentUser!.uid;
  late final ValueNotifier<List<Workout>> _selectedWorkouts;
  late Future<List<DateTime>> _dates;

  @override
  void initState() {
    super.initState();
    _dates = _getWorkoutDates();
    _selectedDay = _focusedDay;
    _selectedWorkouts = ValueNotifier(_getWorkoutsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedWorkouts.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedWorkouts.value = _getWorkoutsForDay(selectedDay);
    }
  }

  List<Workout> _getWorkoutsForDay(DateTime day) {
    List<Workout> temp = workouts[day] ?? [];
    return workouts[day] ?? [];
  }

  Future<List<DateTime>> _getWorkoutDates() async {
    return await service.getDaysWithWorkouts(uid);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final selectedDay = ref.watch(selectedDayProvider);

    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Calendar",
        context: context,
        trailingActions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateWorkout()),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _dates,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading data"),
              );
            } else {
              for (var element in snapshot.data!) {
                DateTime temp =
                    DateTime(element.year, element.month, element.day)
                        .toUtc()
                        .subtract(Duration(hours: 4));

                workouts.addAll({
                  temp: [Workout("TEMP")]
                });
              }

              return Column(
                children: [
                  TableCalendar(
                    eventLoader: _getWorkoutsForDay,
                    firstDay: DateTime(
                      now.year,
                      now.month - 1,
                    ),
                    lastDay: DateTime(now.year, now.month + 2, 0),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(day, _focusedDay);
                    },
                    onDaySelected: _onDaySelected,
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
                  const SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: _selectedWorkouts,
                        builder: (context, value, _) {
                          return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: () => print("tile pressed"),
                                    title: Text("${value[index]}"),
                                  ),
                                );
                              });
                        }),
                  )
                ],
              );
            }
          }),
    );
  }
}
