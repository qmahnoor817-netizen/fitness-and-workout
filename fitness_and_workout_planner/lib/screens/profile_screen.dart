import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async => await auth.signOut(),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: auth.getUserProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data;

          // Show loading while fetching
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4ECDC4)));
          }

          // If no profile exists, show message
          if (profile == null) {
            return const Center(
              child: Text('No profile data found', style: TextStyle(color: Colors.grey)),
            );
          }

          // SHOW REAL DATA FROM FIRESTORE
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF4ECDC4),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name, // REAL NAME FROM DIALOG
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 32),

                _infoTile('Height', '${profile.height.toStringAsFixed(0)} cm'),
                const SizedBox(height: 12),
                _infoTile('Current Weight', '${profile.weight.toStringAsFixed(0)} kg'),
                const SizedBox(height: 12),
                _infoTile('Target Weight', '${profile.targetWeight.toStringAsFixed(0)} kg'),
                const SizedBox(height: 12),
                _infoTile('Goal', profile.goal),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF252542),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}