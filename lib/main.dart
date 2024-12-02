// lib/main.dart
/// Entry point for the AAC Device application.
///
/// This file initializes the app and sets up the main widget tree.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all necessary dart files
import 'features/starting_page.dart';
import 'features/main_page.dart';
import 'features/tutorial_page.dart';
import 'features/aboutUs.dart';
import 'features/login_page.dart';
import 'features/changepassword_form.dart';
import 'features/signup_page.dart';
import 'features/user_profile_page.dart';
import 'features/forum.dart';
import 'firebase/user_provider.dart';
import 'screens/all.dart';
import 'screens/category1.dart';
import 'screens/category2.dart';
import 'screens/category3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: Ulayaw(),
    ),
  );
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
        '/': (context) => StartingPage(),
        '/signup': (context) => AccountCreation(),
        '/login': (context) => LoginPage(),
        '/profile': (context) => UserProfilePage(
              currentUser: '',
              password: '',
            ),
        '/main': (context) {
          final loggedInUser =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return UlayawMainPage(
              loggedInUser: loggedInUser); // Pass loggedInUser here
        },
        // Initial route as starting page
        '/forum': (context) => ForumPage(),
        '/tutorial': (context) => TutorialPage(),
        '/about': (context) => AboutUs(),
        '/forgot-password': (context) => ChangePasswordPage(),
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
