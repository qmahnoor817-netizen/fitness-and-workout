import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../services/firebase_service.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import 'dart:convert';

class AIPlanScreen extends StatefulWidget {
  const AIPlanScreen({super.key});
  @override
  State<AIPlanScreen> createState() => _AIPlanScreenState();
}

class _AIPlanScreenState extends State<AIPlanScreen> {
  String goal = 'Gain muscle';
  int days = 4;
  bool isLoading = false;
  String? errorMsg;

  final List<String> goals = ['Lose weight', 'Gain muscle', 'Maintain'];
  final List<int> daysOptions = [2, 3, 4, 5, 6];

  Future<void> _generatePlan() async {
    setState(() { isLoading = true; errorMsg = null; });
    try {
      final jsonString = await AIService.generateWorkoutPlan(goal, days);
      final data = jsonDecode(jsonString);
      final List<Workout> workouts = [];

      // Parse AI JSON into Workout objects
      for (var dayPlan in data['plan']) {
        List<Exercise> exercises = [];
        for (var ex in dayPlan['exercises']) {
          exercises.add(Exercise(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: ex['name'],
            muscleGroup: dayPlan['focus'],
            sets: ex['sets']?? 3,
            reps: ex['reps']?? 12,
          ));
        }
        workouts.add(Workout(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: dayPlan['focus'] + ' Day',
          day: dayPlan['day'],
          exercises: exercises,
        ));
      }

      // Save all workouts to Firebase
      final firebase = context.read<FirebaseService>();
      for (var w in workouts) {
        await firebase.saveWorkout(w);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI Plan generated & saved!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => errorMsg = 'Failed: $e. Check API key or internet.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Workout Generator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your Fitness Goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: goal,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: goals.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (val) => setState(() => goal = val!),
          ),
          const SizedBox(height: 20),
          const Text('Days per week', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: days,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: daysOptions.map((d) => DropdownMenuItem(value: d, child: Text('$d days'))).toList(),
            onChanged: (val) => setState(() => days = val!),
          ),
          const SizedBox(height: 30),
          if (errorMsg!= null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade100,
              child: Text(errorMsg!, style: const TextStyle(color: Colors.red)),
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isLoading? null : _generatePlan,
              icon: isLoading? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ) : const Icon(Icons.smart_toy),
              label: Text(isLoading? 'Generating...' : 'Generate My Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}