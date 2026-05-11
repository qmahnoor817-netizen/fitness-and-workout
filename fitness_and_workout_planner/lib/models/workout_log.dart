class WorkoutLog {
  final String id;
  final String workoutId;
  final DateTime date;
  final Map<String, int> setsCompleted; // exerciseId : setsDone

  WorkoutLog({
    required this.id,
    required this.workoutId,
    required this.date,
    required this.setsCompleted,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'workoutId': workoutId, 'date': date.toIso8601String(),
    'setsCompleted': setsCompleted,
  };
}