import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/screens/admin_dashboard.dart';
import 'package:flutterflix/screens/profile_screen.dart';
import 'package:flutterflix/screens/trending_movie_screen.dart';

import 'featured_movies_screen.dart';
import 'movie_screen.dart';
import '../services/movie_api.dart';
import '../models/movie_model.dart';
import '../widgets/movie_list_item.dart';

// Home Screen with Bottom Navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  String userName = "Loading...";
  String userEmail = '';
  int _currentIndex = 0; // Track the selected tab

  // Placeholder screens
  final List<Widget> _screens = [
    FeaturedMovies(), // Featured Movies
    TrendingMovies(), // Trending Movies
    ProfileScreen(), // Profile
  ];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchMovies();
  }

  void fetchUserName() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        userName = userDoc['name'];
        userEmail = userDoc['email'];
      });
    } else {
      setState(() {
        userName = "User";
      });
    }
  }

  Future<void> fetchMovies() async {
    final response = await MovieApi.fetchMovies();
    setState(() {
      movies = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.red, size: 25),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 2.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 80, 5, 0),
            child: Center(
              child: Text(
                'Hello $userName',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),
        ),
      ),
      endDrawer: Align(
        alignment: Alignment.topRight, // Align to right center
        child: SizedBox(
          height: 230, // Set custom height
          width: 200, // Small width
          child: Drawer(
            backgroundColor: Colors.black.withOpacity(0.9),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                ListTile(
                  leading: const Icon(Icons.subscriptions, color: Colors.red),
                  title: const Text(
                    "Subscription Status",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.pushNamed(context,
                        '/subscription'); // Navigate to Subscription Page
                  },
                ),
                userEmail == "wajeved04@gmail.com"
                    ? ListTile(
                        leading: const Icon(Icons.dashboard_customize,
                            color: Colors.red),
                        title: const Text(
                          "Admin Dashboard",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close Drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminDashboard()),
                          ); // Navigate to Subscription Page
                        },
                      )
                    : const SizedBox(
                        height: 5,
                      )
              ],
            ),
          ),
        ),
      ),

      backgroundColor: const Color.fromARGB(255, 255, 229, 229),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Featured',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),

      extendBodyBehindAppBar: true,
      body: _screens[_currentIndex], // Show the selected screen
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 25);
    path.quadraticBezierTo(width / 2, height, width, height - 20);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

// Featured Movies Widget
class FeaturedMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeaturedMoviesScreen();
  }
}

class TrendingMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const TrendingMovieScreen();
  }
}
