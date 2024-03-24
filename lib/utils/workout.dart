class Workout {
  final DateTime date;
  final List<Set> sets;

  Workout({
    required this.date,
    required this.sets,
  });
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
  Rep({
    required this.distance,
    required this.numReps,
    required this.repRest,
    required this.repTime,
  });
}
