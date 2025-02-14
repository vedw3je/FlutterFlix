import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password,
      String name, String age, String country, String gender) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          'name': name,
          'age': age,
          'country': country,
          'gender': gender,
          'email': email,
        });

        return user;
      }
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
