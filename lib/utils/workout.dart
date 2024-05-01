/// Model class for [Workout] </br>
/// [date] the workout is assigned to </br>
/// [id] of the workout </br>
/// [sets] List of sets </br>
/// [notes] about the workout (Not implemented) </br>
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

  /// Calculates the total workout distance
  String get totalDistance {
    int totalDistance = 0;
    for (Set set in sets) {
      for (Rep rep in set.reps) {
        totalDistance += int.parse(rep.distance);
      }
    }
    return totalDistance.toString();
  }

  /// Calculates the total workout time
  Duration get totalTime {
    Duration totalTime = Duration();
    for (Set set in sets) {
      for (Rep rep in set.reps) {
        totalTime += rep.repTime;
      }
    }
    return totalTime;
  }
}

/// For activities view, [DisplayWorkout] includes information about the user. </br>
/// [date] of the workout </br>
/// [id] of the workout </br>
/// [sets] in the workout </br>
/// [notes] about the workout (Not implemented) </br>
/// [name] of the athlete </br>
/// [temp] during the workout </br>
/// [weather] during the workout </br>
class DisplayWorkout {
  final DateTime date;
  final String id;
  final List<Set> sets;
  final String notes = '';
  final String name;
  final String temp;
  final String weather;

  DisplayWorkout(
      {required this.id,
      required this.date,
      required this.sets,
      required this.name,
      required this.temp,
      required this.weather});
  String get totalDistance {
    int totalDistance = 0;
    for (Set set in sets) {
      for (Rep rep in set.reps) {
        totalDistance += int.parse(rep.distance) * int.parse(rep.numReps);
      }
    }
    return totalDistance.toString();
  }

  Duration get totalTime {
    Duration totalTime = Duration();
    for (Set set in sets) {
      totalTime += set.setRest;
      for (Rep rep in set.reps) {
        totalTime += rep.repTime * int.parse(rep.numReps);
        totalTime += rep.repRest;
      }
    }
    return totalTime;
  }
}

/// Model class for [Set] </br>
/// [setRest] - rest between this set and the next </br>
/// [reps] - List of [Rep]'s in the current [Set] </br>
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
