class Workout {
  final DateTime date;
  final String id;
  final List<Set> sets;
  final String notes = '';

  Workout({
    required this.id,
    required this.date,
    required this.sets,
  });

  String get totalDistance{
    int totalDistance = 0;
    for (Set set in sets){
      for (Rep rep in set.reps){
        totalDistance += int.parse(rep.distance);
      }
    }
    return totalDistance.toString();
  }

    Duration get totalTime{
      Duration totalTime = Duration();
      for (Set set in sets){
        for (Rep rep in set.reps){
          totalTime += rep.repTime;
        }
      }
      return totalTime;
    }
}

class Set {
  final Duration setRest;
  final List<Rep> reps;
  Set({
    required this.setRest,
    required this.reps,
  });

}

class Rep {
  final String distance;
  final String numReps;
  final Duration repRest;
  final Duration repTime;
  List<Duration>? repRunTimes;
  Rep({
    required this.distance,
    required this.numReps,
    required this.repRest,
    required this.repTime,
    required this.repRunTimes,
  });
}
