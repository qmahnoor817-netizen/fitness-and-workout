import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Checkbox(
          value: workout.isCompleted,
          onChanged: (val) {
            // Update in Firebase
          },
        ),
        title: Text(workout.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${workout.day} • ${workout.exercises.length} exercises'),
        children: workout.exercises.map((ex) => ListTile(
          title: Text(ex.name),
          subtitle: Text(ex.duration > 0? '${ex.duration}s' : '${ex.sets}x${ex.reps}'),
          trailing: IconButton(icon: const Icon(Icons.check_circle_outline), onPressed: () {}),
        )).toList(),
      ),
    );
  }
}