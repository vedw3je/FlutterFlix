import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  double _age = 18;
  final TextEditingController nameController = TextEditingController();
  //final TextEditingController ageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedGender;
  final AuthService authService = AuthService();
  void signUpUser(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    //String age = ageController.text.trim();
    String age = _age.toString();
    String country = countryController.text.trim();
    if (_age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Age must be 18 or above"),
        ),
      );
      return;
    }
    User? user = await authService.signUpWithEmailAndPassword(
        email, password, name, age, country, selectedGender!);

    if (user != null) {
      if (kDebugMode) {
        print("Sign Up successful: ${user.email}");
      }
      Navigator.popAndPushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'CINEFLIX',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/login.png',
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Name"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(34, 158, 158, 158),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Age',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _age,
                                min: 1,
                                max: 100,
                                divisions: 99,
                                activeColor: Colors.red,
                                inactiveColor: Colors.grey,
                                label: _age.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    _age = value;
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _age.round().toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: countryController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Country"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your country" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Gender"),
                    items: ["Male", "Female", "Other"].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedGender = value),
                    validator: (value) =>
                        value == null ? "Select a gender" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter an email";
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                        return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter a password";
                      if (value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Confirm Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Confirm your password";
                      if (value != passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Signup successful!");
                        signUpUser(context);
                      }
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    splashColor: const Color.fromARGB(
                        255, 255, 177, 171), // Light red ripple effect
                    borderRadius: BorderRadius.circular(20),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 60, 60), // Soft red text color
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w500, // Medium weight for a lighter feel
                      ),
                    ), // Optional rounded corners for the ripple effect
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
