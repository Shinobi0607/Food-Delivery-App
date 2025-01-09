import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  // Sign Up
  Future<String?> signUp(String name, String email, String password, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user details in Realtime Database
      await _databaseRef.child('users').child(result.user?.uid ?? '').set({
        'name': name,
        'email': email,
        'phone': phone, // Save phone number
        'createdAt': DateTime.now().toIso8601String(),
      });

      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
