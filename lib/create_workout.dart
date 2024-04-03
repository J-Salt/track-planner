import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleGetAthletes();
    _selectedDate = ref.read(selectedDayProvider);
  }

  void handleGetAthletes() {
    service.getAthletesForAssignment().then((value) {
      setState(() {
        _athletes = ValueNotifier(value);
      });
    });
  }

  List<String> _assignWorkouts(List<Map<String, dynamic>> athletes) {
    List<String> assignedAthletesIds = [];
    for (Map<String, dynamic> athlete in athletes) {
      if (athlete["selected"] == true) {
        assignedAthletesIds.add(athlete["id"]);
      }
    }
    return assignedAthletesIds;
  }

  void _showUserSelectionDialog(BuildContext context) async {
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
                            Navigator.of(context)
                                .pop(false); // Close dialog, return false
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            List<String> assignedAthletesIds =
                                _assignWorkouts(_athletes.value);
                            service.createWorkout(sets, setRests,
                                assignedAthletesIds, _selectedDate);
                            Navigator.of(context).pop();
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
    ).then((selectedUser) {
      if (selectedUser != null) {
        // Call the createWorkout method with the selected user
        //service.createWorkout(sets, setRests, [selectedUser], _selectedDate);
        //widget.updateSelectedWorkouts(
        //widget.getWorkoutsForDay(widget.selectedDay));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Create Workout",
        trailingActions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              //TODO: Remove my id and instead give a list of assigned users

              _showUserSelectionDialog(context);
              //service.createWorkout(sets, setRests,
              //["hl8yydfqLzdcy0cdDp3R6F1Kckq1"], _selectedDate);
              widget.updateSelectedWorkouts(
                  widget.getWorkoutsForDay(widget.selectedDay));

              //Navigator.pop(context);
              //UPDATE _selectedWorkouts = _getWorkoutsForDay(_selectedDay) HERE
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
            setRest: Duration(seconds: 0),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
