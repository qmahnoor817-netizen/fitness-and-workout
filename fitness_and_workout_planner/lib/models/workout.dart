import 'exercise.dart';

class Workout {
  final String id;
  final String name; // Chest Day
  final String day; // Monday
  final List<Exercise> exercises;
  bool isCompleted;
  DateTime? completedDate;

  Workout({
    required this.id,
    required this.name,
    required this.day,
    required this.exercises,
    this.isCompleted = false,
    this.completedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'day': day,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'isCompleted': isCompleted, 'completedDate': completedDate?.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'], name: json['name'], day: json['day'],
    exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    isCompleted: json['isCompleted']?? false,
    completedDate: json['completedDate']!= null? DateTime.parse(json['completedDate']) : null,
  );
}