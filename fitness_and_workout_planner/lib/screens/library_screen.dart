import 'package:flutter/material.dart';
import '../models/exercise.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Exercise> predefined = [
    Exercise(id: '1', name: 'Bench Press', muscleGroup: 'Chest', sets: 3, reps: 10),
    Exercise(id: '2', name: 'Squats', muscleGroup: 'Legs', sets: 4, reps: 12),
    Exercise(id: '3', name: 'Deadlift', muscleGroup: 'Back', sets: 3, reps: 8),
    Exercise(id: '4', name: 'Pull Ups', muscleGroup: 'Back', sets: 3, reps: 10),
    Exercise(id: '5', name: 'Plank', muscleGroup: 'Core', duration: 60),
  ];

  List<Exercise> customExercises = [];

  void _addCustomExercise() {
    // Show dialog to add custom exercise
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Exercise'),
        content: const Text('Form fields here: name, sets, reps, muscle group'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            // Save to Firebase + local list
            Navigator.pop(ctx);
          }, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addCustomExercise)],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Predefined Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...predefined.map((e) => ListTile(
            leading: CircleAvatar(child: Text(e.muscleGroup[0])),
            title: Text(e.name),
            subtitle: Text(e.duration > 0? '${e.duration}s' : '${e.sets}x${e.reps}'),
            trailing: const Icon(Icons.info_outline),
          )),
        ],
      ),
    );
  }
}