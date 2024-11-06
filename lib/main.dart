// lib/main.dart
/// Entry point for the AAC Device application.
///
/// This file initializes the app and sets up the main widget tree.
library;

import 'package:flutter/material.dart';

import 'features/about_page.dart'; // Import AboutPage
import 'features/starting_page.dart'; // Import the StartingPage widget
import 'features/tutorial_page.dart'; //Import TutorialPage
import 'screens/all.dart';
import 'screens/category1.dart';
import 'screens/category2.dart';
import 'screens/category3.dart';

void main() {
  runApp(Ulayaw()); // Start the application by running the MyApp widget
}

/// The root widget of the AAC Device application.

/// This class sets up the MaterialApp with basic configurations like
/// the title, theme, and initial screen.
class Ulayaw extends StatelessWidget {
  const Ulayaw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAC Device', // Application title displayed in task switcher
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set the primary theme color to blue
      ),
      initialRoute: '/', // Added initialRoute
      routes: {
        '/': (context) => StartingPage(), // Initial route as starting page
        '/tutorial': (context) => TutorialPage(),
        '/about': (context) => AboutPage(),
        '/category1': (context) => Category1(), // First Tab
        '/category2': (context) => Category2(), // Second Tab
        '/category3': (context) => Category3(), // Third Tab
        '/all': (context) => All(
              buttons: [],
            ), // Fourth Tab
      },
      debugShowCheckedModeBanner:
          false, // Hide the debug banner in the top right corner
    );
  }
}
