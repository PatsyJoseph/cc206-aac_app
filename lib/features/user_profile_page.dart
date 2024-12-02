import 'dart:io'; // Add this import to use File class

import 'package:Ulayaw/firebase/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/aboutUs.dart'; // Import the About page
import '../features/tutorial_page.dart'; // Import the Tutorial page
import '../screens/nav.dart'; // Import NavDrawer file here

class UserProfilePage extends StatefulWidget {
  final String currentUser;

  UserProfilePage({required this.currentUser, required String password});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? _profileImagePath; // Variable to store the profile image path

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: const Color(0xFF4D8FF8),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: NavDrawer(activeNav: '/profile'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0), // Added more space from the top
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture (square)
                GestureDetector(
                  onTap: _pickImage, // Function to pick a new profile picture
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: _profileImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(_profileImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage('assets/officiallogo.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                // Welcome and Good Day text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $username!',
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4D8FF8),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      'Good Day!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            const SizedBox(height: 20.0),
            // New Section Title
            const Text(
              'Get to know more about TINIG',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            // Tutorial Rectangle
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3D8FF), // Light blue
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    const SizedBox(width: 20.0),
                    const Text(
                      'Tutorial',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // About Us Rectangle
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEEFF), // Even lighter blue
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    const SizedBox(width: 20.0),
                    const Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Centered Email Section with a little space from the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: const Text(
                  'For suggestions and improvements, you can email us at:\n'
                  'tinigaacapplication@gmail.com',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick a profile image
  Future<void> _pickImage() async {
    // Your image picking logic goes here
  }
}
