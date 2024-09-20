import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blank App"),
      ),
     
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Navigate to Home or perform some action
                Navigator.pop(context); // This closes the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to Settings or perform some action
                Navigator.pop(context); // This closes the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle the logout action
                Navigator.pop(context); // This closes the drawer
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'C:\Users\ashle\Flutter\flutter 3\cc206-aac_app\assets\logo.png', 
            height: 100, // Height
          ),
          const SizedBox(height: 20), // Space between logo and text
          const Text(
            'Welcome to Homepage!',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed functionality here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
