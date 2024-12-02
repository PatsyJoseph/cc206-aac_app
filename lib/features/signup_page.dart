import 'package:flutter/material.dart';

import '../firebase/user_service.dart';

class AccountCreation extends StatefulWidget {
  @override
  _AccountCreationState createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  // Text editing controllers for the form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  // State variables for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // State variable for confirm password validation
  bool _isPasswordMatch = true;

  void _validatePasswordMatch() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _passwordConfirmController.text;
    });
  }

  Future<void> _handleCreateAccount() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (!_isPasswordMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      String result = await UserService.createAccount(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth > 400 ? 30.0 : 10.0;
    double verticalSpacing = screenHeight > 400 ? 30.0 : 10.0;
    double buttonHeight = screenHeight > 400 ? 16.0 : 12.0;

    double textFontSize = screenWidth > 400 ? 16.0 : 14.0;
    double titleFontSize = screenWidth > 400 ? 32.0 : 24.0;
    double inputFontSize = screenWidth > 400 ? 16.0 : 14.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding).copyWith(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 800 ? 800 : screenWidth * 0.7,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Page Title
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: titleFontSize,
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
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(fontSize: inputFontSize),
                    decoration: InputDecoration(
                      hintText: 'Enter Username',
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
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(fontSize: inputFontSize),
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  SizedBox(height: 16.0),

                  // Password Confirmation Label and Field
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordConfirmController,
                    onChanged: (_) => _validatePasswordMatch(),
                    style: TextStyle(fontSize: inputFontSize),
                    decoration: InputDecoration(
                      hintText: 'Re-enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: _isPasswordMatch ? Colors.grey : Colors.red,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                  ),
                  SizedBox(height: 8.0),

                  // Error Message for Password Mismatch
                  if (!_isPasswordMatch)
                    Text(
                      'Passwords do not match',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: textFontSize,
                      ),
                    ),
                  SizedBox(height: verticalSpacing),

                  // Create Account Button
                  ElevatedButton(
                    onPressed: _isPasswordMatch
                        ? () async {
                            await _handleCreateAccount();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: buttonHeight),
                      backgroundColor: const Color(0xFF4D8FF8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: screenWidth > 800 ? 20.0 : 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Already have an account link
                  TextButton(
                    onPressed: () {
                      // Navigate to login page using routes
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(color: const Color(0xFF4D8FF8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
