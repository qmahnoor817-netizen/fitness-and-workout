import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  User? get user => _auth.currentUser;

  AuthService() {
    _auth.authStateChanges().listen((_) => notifyListeners());
  }

  Future<void> signUp(String email, String pass) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> signIn(String email, String pass) async {
    await _auth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<void> saveUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toJson());
  }

  Future<UserProfile?> getUserProfile() async {
    if (user == null) return null;
    final doc = await _db.collection('users').doc(user!.uid).get();
    return doc.exists ? UserProfile.fromJson(doc.data()!) : null;
  }
}