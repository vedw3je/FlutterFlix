import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.red,
            ],
          ),
        ),
        child: AnimatedSplashScreen(
          backgroundColor: kDefaultIconDarkColor,
          splash: const Text(
            'FLUTTERFLIX',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.red,
              fontWeight: FontWeight.w900,
              fontSize: 40,
            ),
          ),
          nextScreen: const HomeScreen(),
          animationDuration: Duration(seconds: 2),
          splashTransition: SplashTransition.slideTransition,
          centered: true,
          pageTransitionType: PageTransitionType.leftToRightWithFade,
          curve: Easing.legacy,
        ),
      ),
    );
  }
}
