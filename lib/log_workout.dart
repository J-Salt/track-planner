import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/workout.dart';

class LogWorkout extends StatefulWidget {
  const LogWorkout({super.key, required this.workout});
  final Workout workout;

  @override
  _LogWorkoutState createState() => _LogWorkoutState();
}

class _LogWorkoutState extends State<LogWorkout> {
  int _selectedSet = 0;
  int _selectedRep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Workout",
        trailingActions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Service().logWorkout(Auth().currentUser!.uid, widget.workout.id,
                  widget.workout.sets);
              Navigator.of(context).pop();
            },
          )
        ],
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
                            setState(() {
                              _selectedSet = setIndex;
                              _selectedRep = repIndex;
                            });

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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${repIndex + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      Icon(
                                        Icons.check,
                                        color: Colors.green.withOpacity(widget
                                                    .workout
                                                    .sets[setIndex]
                                                    .reps[repIndex]
                                                    .repRunTimes
                                                    ?.length ==
                                                int.parse(widget
                                                    .workout
                                                    .sets[setIndex]
                                                    .reps[repIndex]
                                                    .numReps)
                                            ? 1
                                            : 0),
                                      )
                                    ],
                                  ),
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

  Future<bool?> _showUserSelectionDialog(
      BuildContext context, Rep selectedRep) async {
    List<TextEditingController> controllers = List.generate(
      int.parse(selectedRep.numReps),
      (index) => TextEditingController(),
    );
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
                                  SizedBox(
                                    width: 130,
                                    child: TextField(
                                      controller: controllers[index],
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
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
                        List<Duration> times = controllers
                            .map((c) => Service().parseDuration2(c.text))
                            .toList();
                        if (hasNonZeroDurations(times)) {
                          setState(() {
                            widget.workout.sets[_selectedSet].reps[_selectedRep]
                                .repRunTimes = times;
                          });
                        }

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

  bool hasNonZeroDurations(List<Duration> durations) {
    //check if a list of durations contains all zeros
    for (var duration in durations) {
      if (duration != Duration.zero) {
        return true;
      }
    }
    return false;
  }
}
