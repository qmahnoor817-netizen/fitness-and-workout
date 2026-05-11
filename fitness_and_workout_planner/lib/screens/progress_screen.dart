import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return FutureBuilder<UserProfile?>(
      future: auth.getUserProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        // If no profile yet, show loading
        if (profile == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF4ECDC4))),
          );
        }

        // Calculate progress percentage
        double progress = 0.0;
        int daysCompleted = 0; // TODO: Get from Firestore workout logs

        if (profile.goal == 'Weight Loss') {
          // For loss: progress = (start - current) / (start - target)
          double totalToLose = profile.weight - profile.targetWeight;
          if (totalToLose > 0) {
            progress = 0.0; // Will update when user logs weight
          }
        } else if (profile.goal == 'Gain') {
          // For gain: progress = (current - start) / (target - start)
          double totalToGain = profile.targetWeight - profile.weight;
          if (totalToGain > 0) {
            progress = 0.0; // Will update when user logs weight
          }
        } else {
          progress = 1.0; // Maintain = already at goal
        }

        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A1A2E),
            elevation: 0,
            title: const Text('Your Body Composition', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async => await auth.signOut(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // CIRCULAR PROGRESS
                SizedBox(
                  width: 180, height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180, height: 180,
                        child: CircularProgressIndicator(
                          value: daysCompleted > 0 ? daysCompleted / 7 : 0,
                          strokeWidth: 12,
                          backgroundColor: const Color(0xFF252542),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(profile.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('Activity Record', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // GREAT JOB TEXT - Only show if workouts done
                Text(
                  daysCompleted > 0 ? 'Great Job!' : 'Start Your Journey!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  daysCompleted > 0
                      ? 'Successfully completed Day $daysCompleted Training'
                      : 'Add your first workout to track progress',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // STATS CARDS - REAL DATA FROM PROFILE
                Row(
                  children: [
                    _statCard('${profile.weight.toStringAsFixed(0)}kg', 'Start Weight'),
                    const SizedBox(width: 12),
                    _statCard('${profile.targetWeight.toStringAsFixed(0)}kg', 'Target Weight'),
                    const SizedBox(width: 12),
                    _statCard(_calculateCalories(profile), 'Daily Calories'),
                  ],
                ),
                const SizedBox(height: 32),

                // EMPTY CHART SECTION
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xFF252542), borderRadius: BorderRadius.circular(16)),
                  child: daysCompleted == 0
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.show_chart, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No workout data yet', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text('Complete workouts to see your progress', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                      : const Center(child: Text('Chart coming soon', style: TextStyle(color: Colors.grey))),
                ),

                const SizedBox(height: 24),
                // GOAL INFO
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF252542), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Goal', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(profile.goal, style: const TextStyle(color: Color(0xFF4ECDC4), fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        profile.goal == 'Maintain'
                            ? 'Stay fit!'
                            : '${(profile.targetWeight - profile.weight).abs().toStringAsFixed(0)}kg to go',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFF252542), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _calculateCalories(UserProfile p) {
    // Basic BMR formula: Mifflin-St Jeor
    double bmr = 10 * p.weight + 6.25 * p.height - 5 * 25; // assuming age 25
    bmr = p.goal == 'Gain' ? bmr + 500 : p.goal == 'Weight Loss' ? bmr - 500 : bmr;
    return '${bmr.toStringAsFixed(0)} Cal';
  }
}