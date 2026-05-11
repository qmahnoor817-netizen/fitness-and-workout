import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';
import 'planner_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  UserProfile? profile;

  // CRITICAL: This list must have SAME LENGTH as BottomNavigationBar items
  final List<Widget> _screens = const [
    PlannerScreen(),   // Index 0
    ProgressScreen(),  // Index 1
    ProfileScreen(),   // Index 2
  ];

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  void _checkProfile() async {
    final auth = context.read<AuthService>();
    final p = await auth.getUserProfile();
    if (p == null && mounted) {
      _showProfileDialog();
    } else {
      setState(() => profile = p);
    }
  }

  void _showProfileDialog() {
    final name = TextEditingController();
    final height = TextEditingController();
    final weight = TextEditingController();
    String goal = 'Maintain';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF252542),
          title: const Text('Complete Your Profile', style: TextStyle(color: Colors.white)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.grey))),
            TextField(controller: height, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Height cm', labelStyle: TextStyle(color: Colors.grey))),
            TextField(controller: weight, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Current Weight kg', labelStyle: TextStyle(color: Colors.grey))),
            DropdownButton<String>(
              value: goal, isExpanded: true, dropdownColor: const Color(0xFF252542),
              style: const TextStyle(color: Colors.white),
              items: ['Weight Loss', 'Gain', 'Maintain'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setDialogState(() => goal = v!),
            ),
          ]),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ECDC4)),
                onPressed: () async {
                  Navigator.pop(ctx); // Close first dialog

                  // If Weight Loss or Gain, show second dialog for target
                  if (goal == 'Weight Loss' || goal == 'Gain') {
                    _showTargetWeightDialog(
                        name.text,
                        double.parse(height.text),
                        double.parse(weight.text),
                        goal
                    );
                  } else {
                    // Maintain - save directly with same weight as target
                    final auth = context.read<AuthService>();
                    final newProfile = UserProfile(
                      uid: auth.user!.uid,
                      email: auth.user!.email!,
                      name: name.text,
                      height: double.parse(height.text),
                      weight: double.parse(weight.text),
                      goal: goal,
                      targetWeight: double.parse(weight.text), // Same as current for maintain
                    );
                    await auth.saveUserProfile(newProfile);
                    _checkProfile();
                  }
                },
                child: const Text('Complete', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ADD THIS NEW METHOD BELOW _showProfileDialog()
  void _showTargetWeightDialog(String name, double height, double currentWeight, String goal) {
    final targetWeight = TextEditingController();
    String hintText = goal == 'Weight Loss' ? 'Target Weight kg' : 'Target Weight kg';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252542),
        title: Text('Set Your $goal Goal', style: const TextStyle(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Current: ${currentWeight}kg', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: targetWeight,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4ECDC4))),
            ),
          ),
        ]),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ECDC4)),
              onPressed: () async {
                final auth = context.read<AuthService>();
                final newProfile = UserProfile(
                  uid: auth.user!.uid,
                  email: auth.user!.email!,
                  name: name,
                  height: height,
                  weight: currentWeight,
                  goal: goal,
                  targetWeight: double.parse(targetWeight.text),
                );
                await auth.saveUserProfile(newProfile);
                Navigator.pop(ctx);
                _checkProfile();
              },
              child: const Text('Save Goal', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF252542),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF4ECDC4),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // CRITICAL: Must have EXACTLY 3 items because _screens has 3 items
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}