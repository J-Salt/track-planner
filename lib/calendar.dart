import 'package:firebase_auth/firebase_auth.dart';
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
  late Future<Map<DateTime, List<Workout>>> _dates;
  late User _user;
  bool _isCoach = false;

  @override
  void initState() {
    super.initState();
    _dates = _getWorkoutDates();
    _user = Auth().currentUser!;
    isCurrentUserCoach(_user.uid);
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

  Future<Map<DateTime, List<Workout>>> _getWorkoutDates() async {
    return await service.getWorkouts(uid);
  }

  void isCurrentUserCoach(String uid) {
    service.getUser(uid).then(
      (value) {
        setState(() {
          _isCoach = value["isCoach"] as bool;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final selectedDay = ref.watch(selectedDayProvider);

    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Calendar",
        context: context,
        trailingActions: _isCoach
            ? [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateWorkout(
                        selectedDay: _selectedDay!,
                        getWorkoutsForDay: _getWorkoutsForDay,
                        updateSelectedWorkouts: (workouts) {
                          setState(() {
                            _selectedWorkouts.value = workouts;
                          });
                        },
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ]
            : [],
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
            workouts = snapshot.data!;
            return Column(
              children: [
                TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  rowHeight: 38,
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
                    headerPadding: EdgeInsets.symmetric(vertical: 2),
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, date, _) {
                      final isSelected = isSameDay(date, selectedDay);
                      return SizedBox(
                        width: 36,
                        height: 36,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color.fromARGB(255, 227, 227, 227)
                                : null,
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.black : null,
                            ),
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, date, _) {
                      final isSelected = isSameDay(date, selectedDay);
                      return SizedBox(
                        width: 48,
                        height: 48,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Workouts",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: _selectedWorkouts,
                            builder: (context, value, _) {
                              return ListView.builder(
                                //build workouts
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Wrap(
                                      children: [
                                        Container(
                                          width: 600,
                                          height: 400,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: ListView.builder(
                                              //build sets
                                              itemCount:
                                                  value[index].sets.length,
                                              itemBuilder: (context, setIndex) {
                                                return Card(
                                                  elevation: 2,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 600,
                                                        height: 150,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: ListView.builder(
                                                          //build reps
                                                          itemCount: value[
                                                                  index]
                                                              .sets[setIndex]
                                                              .reps
                                                              .length,
                                                          itemBuilder: (context,
                                                              repIndex) {
                                                            return Card(
                                                              elevation: 3,
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "${repIndex + 1}",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16,
                                                                        )),
                                                                    const Divider(),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "${value[index].sets[setIndex].reps[repIndex].distance}m x ${value[index].sets[setIndex].reps[repIndex].numReps}"),
                                                                        const SizedBox(
                                                                          width:
                                                                              50,
                                                                        ),
                                                                        const Icon(
                                                                            Icons.timer),
                                                                        Text(
                                                                            //TODO change to repTime (How long to complete each rep)
                                                                            "${value[index].sets[setIndex].reps[repIndex].repTime.inMinutes}:${value[index].sets[setIndex].reps[repIndex].repTime.inSeconds % 60 == 0 ? "00" : value[index].sets[setIndex].reps[repIndex].repTime.inSeconds % 60}")
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                        "Rest: ${value[index].sets[setIndex].reps[repIndex].repRest.inMinutes}:${value[index].sets[setIndex].reps[repIndex].repRest.inSeconds % 60 == 0 ? "00" : value[index].sets[setIndex].reps[repIndex].repRest.inSeconds % 60}")
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
