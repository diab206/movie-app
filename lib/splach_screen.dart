import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/home_page/home_page.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash';

  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>  HomePage()),
        (Route<dynamic> route) => false, // Remove all routes
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF121312), // Set the background color of the entire screen
      body: Center(
        child: SizedBox(
          width: 150, // Set the width of the logo
          height: 150, // Set the height of the logo
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/movies.png'),
                fit: BoxFit.contain, // Ensures the logo fits within the SizedBox
              ),
            ),
          ),
        ),
      ),
    );
  }
}