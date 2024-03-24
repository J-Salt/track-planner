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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = ref.read(selectedDayProvider);
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
              service.createWorkout(sets, setRests,
                  ["hl8yydfqLzdcy0cdDp3R6F1Kckq1"], _selectedDate);
              widget.updateSelectedWorkouts(
                  widget.getWorkoutsForDay(widget.selectedDay));
              Navigator.pop(context);
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
