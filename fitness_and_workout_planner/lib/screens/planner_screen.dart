import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});
  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _customExercises = [];

  void _addCustomExercise() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252542),
        title: const Text('Add Exercise', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Exercise name', hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4ECDC4))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ECDC4)),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _customExercises.add({
                    'name': nameController.text,
                    'date': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }

  void _searchWithAI() {
    if (_searchController.text.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('AI searching for: ${_searchController.text}'), backgroundColor: const Color(0xFF4ECDC4)),
    );
    // TODO: Call your AI service here with _searchController.text
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return FutureBuilder<UserProfile?>(
      future: auth.getUserProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER WITH LOGOUT INSTEAD OF MENU
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(radius: 24, backgroundColor: Color(0xFF4ECDC4), child: Icon(Icons.person, color: Colors.white)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Welcome!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text(profile?.name ?? 'User', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      // LOGOUT BUTTON
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async => await auth.signOut(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. SEARCH BAR WITH AI BUTTON
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    decoration: BoxDecoration(color: const Color(0xFF252542), borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search workout with AI...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _searchWithAI(),
                          ),
                        ),
                        // AI BUTTON
                        IconButton(
                          icon: const Icon(Icons.auto_awesome, color: Color(0xFF4ECDC4)),
                          onPressed: _searchWithAI,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. YOUR PROGRESS - WEIGHT LOSS & WEIGHT GAIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Workout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      TextButton(onPressed: () {}, child: const Text('View all >', style: TextStyle(color: Color(0xFF4ECDC4)))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _progressCard('Weight Loss\nWorkouts', 'HIIT, Cardio', const Color(0xFF4ECDC4), Icons.local_fire_department),
                      const SizedBox(width: 12),
                      _progressCard('Weight Gain\nWorkouts', 'Strength, Bulk', const Color(0xFFA29BFE), Icons.fitness_center),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 4. LAST EXERCISES - CUSTOM ADD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Last Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFF4ECDC4)),
                        onPressed: _addCustomExercise,
                      ),
                    ],
                  ),
                  if (_customExercises.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('No exercises yet. Tap + to add', style: TextStyle(color: Colors.grey))),
                    )
                  else
                    ..._customExercises.map((ex) => _exerciseTile(ex['name']!, ex['date']!)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _progressCard(String title, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _exerciseTile(String name, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF252542), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4ECDC4), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}