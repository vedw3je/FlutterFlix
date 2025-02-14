import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_detail.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void signOutUser() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
  }

  void deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .delete(); // Delete Firestore doc
        await user.delete(); // Delete Firebase Authentication account
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 185, 185), // Netflix dark theme

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : userData == null
              ? const Center(
                  child: Text("No user data found",
                      style: TextStyle(color: Colors.white)))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: const AssetImage('assets/profile.jpg'),
                      backgroundColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.6), // Slight transparency effect
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red, width: 2), // Red border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red
                                .withOpacity(0.4), // Soft red glow effect
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              userData!['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(
                              color: Colors.red.withOpacity(0.6), thickness: 1),
                          const SizedBox(height: 10),
                          profileDetail("Age", "${userData!['age']}"),
                          profileDetail("Gender", "${userData!['gender']}"),
                          profileDetail("Country", "${userData!['country']}"),
                          const SizedBox(height: 10),
                          Divider(
                              color: Colors.red.withOpacity(0.6), thickness: 1),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Subscription: ${userData!['subscription']}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Buttons
                    buildButton("Sign Out", Colors.red, signOutUser),
                    buildButton(
                        "Delete Account", Colors.grey[800]!, deleteAccount),
                  ],
                ),
    );
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 20,
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  final textStyle = const TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
}
