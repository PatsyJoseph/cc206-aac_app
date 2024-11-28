// lib/main.dart
/// Entry point for the AAC Device application.
///
/// This file initializes the app and sets up the main widget tree.
library;

import 'package:Ulayaw/features/aboutUs.dart';
import 'package:flutter/material.dart';

// Import all necessary dart files
import 'features/main_page.dart';
import 'features/tutorial_page.dart';
import 'screens/all.dart';
import 'screens/category1.dart';
import 'screens/category2.dart';
import 'screens/category3.dart';

void main() {
  runApp(Ulayaw());

  /// The root widget of the AAC Device application.

  /// This class sets up the MaterialApp with basic configurations like
  /// the title, theme, and initial screen.
}

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
        '/': (context) => UlayawMainPage(), // Initial route as starting page
        '/tutorial': (context) => TutorialPage(),
        '/about': (context) => AboutUs(),
        '/category1': (context) => Category1(
              buttons: [],
              onButtonPressed: (int) {},
              onButtonLongPress: (int) {},
              animationControllers: [],
              isDeleteMode: false,
            ), // First Category
        '/category2': (context) => Category2(
              buttons: [],
              onButtonPressed: (int) {},
              onButtonLongPress: (int) {},
              animationControllers: [],
              isDeleteMode: false,
            ), // Second Category
        '/category3': (context) => Category3(
              buttons: [],
              onButtonPressed: (int) {},
              onButtonLongPress: (int) {},
              animationControllers: [],
              isDeleteMode: false,
            ), // Third Category
        '/all': (context) => All(
              buttons: [],
              onButtonPressed: (int) {},
              onButtonLongPress: (int) {},
              animationControllers: [],
              isDeleteMode: false,
            ), // Tab containing buttons for all categories
      },
      debugShowCheckedModeBanner:
          false, // Hide the debug banner in the top right corner
    );
  }
}
