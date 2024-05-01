import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/calendar.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/set.dart';
import 'package:track_planner/utils/workout.dart'
    as model; // Assuming Rep widget is in a file named 'rep.dart'

class CreateWorkout extends ConsumerStatefulWidget {
  final void Function(List<model.Workout>) updateSelectedWorkouts;
  final List<model.Workout> Function(DateTime) getWorkoutsForDay;
  final DateTime selectedDay;

  const CreateWorkout({
    super.key,
    required this.updateSelectedWorkouts,
    required this.getWorkoutsForDay,
    required this.selectedDay,
  });

  @override
  _CreateWorkoutState createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends ConsumerState<CreateWorkout> {
  Service service = Service();
  List<List<Map<String, String>>> sets = [[]];
  List<Duration> setRests = [];
  late DateTime _selectedDate;
  late final ValueNotifier<List<Map<String, dynamic>>> _athletes;
  bool donePressed = false;
  User user = Auth().currentUser!;

  @override
  void initState() {
    super.initState();
    handleGetAthletes();
    _selectedDate = ref.read(selectedDayProvider);
  }

  // Get list of athletes for assigning workouts to
  void handleGetAthletes() {
    service.getAthletesForAssignment(user.uid).then((value) {
      setState(() {
        _athletes = ValueNotifier(value);
      });
    });
  }

  // Gather list of uid's for workout assignment
  List<String> _assignWorkouts(List<Map<String, dynamic>> athletes) {
    List<String> assignedAthletesIds = [];
    for (Map<String, dynamic> athlete in athletes) {
      if (athlete["selected"] == true) {
        assignedAthletesIds.add(athlete["id"]);
      }
    }
    return assignedAthletesIds;
  }

  // Show the popup window for selecting athletes
  Future<bool?> _showUserSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _athletes,
          builder: (context, value, _) {
            return Dialog(
              child: SizedBox(
                width: 200,
                height: 550,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: _athletes.value[index]["selected"],
                                    onChanged: (isSelected) {
                                      _athletes.value[index]["selected"] =
                                          isSelected ?? false;
                                      // Used to rebuild the checkboxes
                                      _athletes.notifyListeners();
                                    },
                                  ),
                                  const SizedBox(width: 30),
                                  Text("${value[index]["name"]}"),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            donePressed = false;
                            Navigator.of(context)
                                .pop(false); // Close dialog, return false
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Assign the workouts to selected athletes
                            List<String> assignedAthletesIds =
                                _assignWorkouts(_athletes.value);
                            service.createWorkout(sets, setRests,
                                assignedAthletesIds, _selectedDate);
                            donePressed = true;
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Create Workout",
        trailingActions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _showUserSelectionDialog(context).then((_) {
                if (donePressed) {
                  Navigator.of(context).pop();
                }
              });
              // Callback function to update the workouts for the selected day
              widget.updateSelectedWorkouts(
                  widget.getWorkoutsForDay(widget.selectedDay));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          return Set(
            index: index,
            reps: sets[index],
            setRest: Duration.zero,
            onAddRep: () {
              setState(() {
                sets[index].add({
                  'distance': '',
                  'numReps': '',
                  'repRest': '',
                  'repTime': '',
                });
              });
            },
            onSetRestChanged: (value) {
              setState(() {
                setRests.add(value);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            sets.add([]);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
