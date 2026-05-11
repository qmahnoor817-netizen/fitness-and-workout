class Exercise {
  final String id;
  final String name;
  final String muscleGroup; // Chest, Leg, Back
  final int sets;
  final int reps;
  final int duration; // in seconds, 0 if rep-based
  final String? imageUrl;
  final bool isCustom;

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    this.sets = 3,
    this.reps = 12,
    this.duration = 0,
    this.imageUrl,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'muscleGroup': muscleGroup,
    'sets': sets, 'reps': reps, 'duration': duration,
    'imageUrl': imageUrl, 'isCustom': isCustom
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'], name: json['name'], muscleGroup: json['muscleGroup'],
    sets: json['sets'], reps: json['reps'], duration: json['duration'],
    imageUrl: json['imageUrl'], isCustom: json['isCustom']?? false,
  );
}