import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/workout.dart';

class FirebaseService extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveWorkout(Workout workout) async {
    final uid = _auth.currentUser?.uid;
    if(uid==null) return;
    await _db.collection('users').doc(uid).collection('workouts').doc(workout.id).set(workout.toJson());
  }

  Stream<List<Workout>> getWorkouts() {
    final uid = _auth.currentUser?.uid;
    return _db.collection('users').doc(uid).collection('workouts')
        .snapshots().map((snap) => snap.docs.map((d) => Workout.fromJson(d.data())).toList());
  }
}