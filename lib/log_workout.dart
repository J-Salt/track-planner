import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/workout.dart';

class LogWorkout extends StatefulWidget {
  const LogWorkout({super.key, required this.workout});
  final Workout workout;

  @override
  _LogWorkoutState createState() => _LogWorkoutState();
}

class _LogWorkoutState extends State<LogWorkout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool?> _showUserSelectionDialog(
      BuildContext context, Rep selectedRep) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 550,
            child: Column(
              children: [
                Text(
                  "${selectedRep.distance} x ${selectedRep.numReps}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: int.parse(selectedRep.numReps),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "${index + 1}: ${selectedRep.distance}m :"),
                                  const SizedBox(
                                    width: 130,
                                    child: TextField(
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.directions_run),
                                          hintText: "MM:SS.SS"),
                                    ),
                                  ),
                                ],
                              ),
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
                            .pop(); // Close dialog, return false
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Workout",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          //build sets
          itemCount: widget.workout.sets.length, //access workout here
          itemBuilder: (context, setIndex) {
            return Card(
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    width: 600,
                    height: widget.workout.sets[setIndex].reps.length * 100,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      //build reps
                      itemCount: widget.workout.sets[setIndex].reps.length,
                      itemBuilder: (context, repIndex) {
                        return InkWell(
                          onTap: () async {
                            print("Set: $setIndex, Rep: $repIndex");
                            await _showUserSelectionDialog(context,
                                widget.workout.sets[setIndex].reps[repIndex]);
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${repIndex + 1}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Text(
                                          "${widget.workout.sets[setIndex].reps[repIndex].distance}m x ${widget.workout.sets[setIndex].reps[repIndex].numReps}"),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      const Icon(Icons.timer),
                                      Text(
                                          "${widget.workout.sets[setIndex].reps[repIndex].repTime.inMinutes}:${widget.workout.sets[setIndex].reps[repIndex].repTime.inSeconds % 60 == 0 ? "00" : widget.workout.sets[setIndex].reps[repIndex].repTime.inSeconds % 60}")
                                    ],
                                  ),
                                  Text(
                                      "Rest: ${widget.workout.sets[setIndex].reps[repIndex].repRest.inMinutes}:${widget.workout.sets[setIndex].reps[repIndex].repRest.inSeconds % 60 == 0 ? "00" : widget.workout.sets[setIndex].reps[repIndex].repRest.inSeconds % 60}")
                                ],
                              ),
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
    );
  }

  void onTap(String title) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' minutes')),
        const NumberPickerColumn(
            begin: 0, end: 55, suffix: Text(' seconds'), jump: 5),
        const NumberPickerColumn(
            begin: 0, end: 9, suffix: Text(' milliseconds'), jump: 1),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: const Text(
              ":",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: const Text(
              ".",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      confirmTextStyle:
          const TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: Text(title),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        Duration _duration = Duration(
            minutes: picker.getSelectedValues()[0],
            seconds: picker.getSelectedValues()[1]);
      },
    ).showDialog(context);
  }
}
