import 'package:flutter/material.dart';
import 'package:movie_app/home_page/home_page.dart';
import 'package:movie_app/provider/provider.dart';
import 'package:movie_app/splach_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyApplication();
  }
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        initialRoute: HomePage.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomePage.routeName: (context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}