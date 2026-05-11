import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';
import '../models/user_profile.dart';

class LocalStorage {
  static const String _workoutsKey = 'cached_workouts';
  static const String _profileKey = 'cached_profile';

  // Cache workouts for offline use
  static Future<void> saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = workouts.map((w) => w.toJson()).toList();
    await prefs.setString(_workoutsKey, jsonEncode(jsonList));
  }

  static Future<List<Workout>> getCachedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_workoutsKey);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((w) => Workout.fromJson(w)).toList();
  }

  // Cache user profile
  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  static Future<UserProfile?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(jsonDecode(data));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}