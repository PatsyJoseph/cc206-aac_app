// lib/main.dart
/// Entry point for the AAC Device application.
///
/// This file initializes the app and sets up the main widget tree.
library;

import 'package:flutter/material.dart';

import 'features/about_page.dart'; // Import AboutPage
import 'features/starting_page.dart'; // Import the StartingPage widget
import 'features/tutorial_page.dart'; //Import TutorialPage

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
      },
      debugShowCheckedModeBanner:
          false, // Hide the debug banner in the top right corner
    );
  }
}
