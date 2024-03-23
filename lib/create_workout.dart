import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_planner/calendar.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/set.dart'; // Assuming Rep widget is in a file named 'rep.dart'

class CreateWorkout extends ConsumerStatefulWidget {
  const CreateWorkout();

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
              Navigator.pop(context);
            },
          )
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
