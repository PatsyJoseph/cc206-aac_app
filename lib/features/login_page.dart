import 'package:Ulayaw/firebase/user_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/user_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // To show a loading indicator during login

  Future<void> handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String loggedInUser = await UserService.login(username, password);

      Provider.of<UserProvider>(context, listen: false)
          .setCurrentUser(loggedInUser);

      // Pass the logged-in user to the next screen
      Navigator.pushNamed(context, '/main', arguments: loggedInUser);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Sets horizontal padding based on screen width
    double horizontalPadding = screenWidth > 500 ? 32.0 : 16.0;
    // Adjust vertical spacing based on height
    double verticalSpacing = screenHeight > 800 ? 32.0 : 24.0;
    // Adjust button height based on screen height
    double buttonHeight = screenHeight > 800 ? 16.0 : 12.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 400 ? 400 : screenWidth * 0.9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo display
                Center(
                  child: Image.asset(
                    'assets/officiallogo.png',
                    height: 120.0,
                  ),
                ),
                SizedBox(height: verticalSpacing),

                // Page Title
                Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing),

                // Username Label and Field
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Password Label and Field
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: verticalSpacing),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonHeight),
                    backgroundColor: const Color(0xFF4D8FF8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: screenWidth > 400 ? 16.0 : 14.0,
                            color: Colors.white,
                          ),
                        ),
                ),
                SizedBox(height: 16.0),

                // Forgot password link
                TextButton(
                  onPressed: () {
                    // Navigate to forgot password page
                    // Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: const Color(0xFF4D8FF8)),
                  ),
                ),

                // Don't have an account text
                TextButton(
                  onPressed: () {
                    // Navigate to account creation page
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    "Don't have an account? Sign up here",
                    style: TextStyle(color: const Color(0xFF4D8FF8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
