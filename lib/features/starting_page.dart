// lib/features/starting_page.dart
//
// This file defines the StartingPage widget, which serves as the splash screen
// for the application. It displays the app logo, title, and description, and
// navigates to the MainPage after a brief delay.

import 'package:flutter/material.dart';

import 'main_page.dart'; // Import MainPage for navigation

/// StartingPage widget acts as a splash screen displayed when the app launches.
///
/// It shows the app logo, title, and description before navigating to the
/// MainPage after a 3-second delay.
class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to MainPage after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set the background color of the page to white
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the content vertically
          children: [
            // Display the app logo as a circular blue icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.blue, // Logo background color
                shape: BoxShape.circle, // Make the logo circular
              ),
            ),
            const SizedBox(height: 20), // Add space below the logo
            // Display the app title
            const Text(
              'App Title',
              style: TextStyle(
                fontSize: 24, // Font size for the title
                fontWeight: FontWeight.bold, // Bold font style
              ),
            ),
            const SizedBox(height: 10), // Add space below the title
            // Display a brief description of the app
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 40.0), // Horizontal padding
              child: Text(
                'A brief description of the app goes here. It could be a tagline or purpose statement.',
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontSize: 14, // Font size for the description
                  color: Colors.grey, // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
