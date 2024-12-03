// changepassword.dart allows user to change their password and updating it in
// Firestore

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false; // To toggle visibility of new password
  bool _isConfirmPasswordVisible =
      false; // To toggle visibility of confirm password
  bool _isPasswordMatch = true; // To check if passwords match
  bool _isPasswordLengthValid =
      true; // To check the character length meets the criteria

  void _validatePasswordLength() {
    setState(() {
      _isPasswordLengthValid = _newPasswordController.text.length >= 8;
    });
  }

  // Function to handle password change
  Future<void> handlePasswordChange() async {
    final username = _usernameController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    try {
      // Hash the new password
      final hashedPassword =
          sha256.convert(utf8.encode(newPassword)).toString();

      // Locate user document by username
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User not found.');
      }

      final userDoc = userQuery.docs.first.reference;

      // Update the password in Firestore
      await userDoc.update({
        'password': hashedPassword,
        'passwordUpdatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully!')),
      );

      Navigator.pop(context); // Navigate back after success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth > 500 ? 32.0 : 16.0;
    double verticalSpacing = screenHeight > 800 ? 32.0 : 24.0;
    double buttonHeight = screenHeight > 800 ? 16.0 : 12.0;
    double textFontSize = screenWidth > 400 ? 16.0 : 14.0;

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
                // Page Title
                Text(
                  'Change Your Password',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing),

                // Username Field
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

                // New Password Field
                Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _newPasswordController,
                  onChanged: (_) => _validatePasswordLength(),
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Enter your new password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                if (!_isPasswordLengthValid)
                  Text(
                    'Password must be at least 8 characters long',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: textFontSize,
                    ),
                  ),
                SizedBox(height: 16.0),

                // Confirm New Password Field
                Text(
                  'Confirm New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Confirm your new password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isPasswordMatch = value == _newPasswordController.text;
                    });
                  },
                ),
                SizedBox(height: 8.0),

                // Password Match Error Message
                if (!_isPasswordMatch)
                  Text(
                    'Passwords do not match',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: verticalSpacing),

                // Change Password Button
                ElevatedButton(
                  onPressed:
                      _isPasswordLengthValid ? handlePasswordChange : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonHeight),
                    backgroundColor: const Color(0xFF4D8FF8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 16.0 : 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Option to go back to login or sign up
                TextButton(
                  onPressed: () {
                    // Optionally, navigate back to login page
                    Navigator.pop(context); // Go back to previous screen
                  },
                  child: Text(
                    "Back to Login",
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
