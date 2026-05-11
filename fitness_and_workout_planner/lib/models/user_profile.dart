class UserProfile {
  final String uid, email, name, goal;
  final double height, weight, targetWeight;

  UserProfile({
    required this.uid, required this.email, required this.name,
    required this.height, required this.weight, required this.goal,
    required this.targetWeight,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid, 'email': email, 'name': name,
    'height': height, 'weight': weight, 'goal': goal,
    'targetWeight': targetWeight,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    uid: json['uid'] ?? '',
    email: json['email'] ?? '',
    name: json['name'] ?? 'User',
    height: (json['height'] ?? 0).toDouble(),
    weight: (json['weight'] ?? 0).toDouble(),
    goal: json['goal'] ?? 'Maintain',
    targetWeight: (json['targetWeight'] ?? json['weight'] ?? 0).toDouble(), // FALLBACK TO CURRENT WEIGHT
  );
}