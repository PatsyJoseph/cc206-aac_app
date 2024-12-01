import 'package:Ulayaw/features/login_page.dart';
import 'package:flutter/material.dart';

/// StartingPage widget acts as a splash screen displayed when the app launches.
///
/// It shows the app logo, title, and description before navigating to the
/// MainPage when tapped.
class StartingPage extends StatefulWidget {
  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to MainPage when tapped
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 176, 234, 177), Colors.white],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/officiallogo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 15),
              const Text(
                'TINIG',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                ),
              ),
              const Text('Tap anywhere to start',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 117, 117, 117),
                    fontSize: 15,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
