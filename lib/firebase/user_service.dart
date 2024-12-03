// user_service.dart handles the data including the username and password entered
// by the user and store it in firestore.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class UserService {
  static Future<String> createAccount(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    try {
      // Generate a unique ID for the user
      var uuid = Uuid();
      String userId = uuid.v4();
      // Hash the password for security
      var hashedPassword = sha256.convert(utf8.encode(password)).toString();
      // Save the user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'userId': userId,
        'username': username,
        'password': hashedPassword,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Data successfully written to Firestore.');

      // Verify the document exists
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        print('Document verified: ${snapshot.data()}');
        return 'Account created successfully!';
      } else {
        throw Exception('Failed to verify account creation.');
      }
    } catch (e) {
      print('Error creating account: $e');
      throw Exception('Failed to create account');
    }
  }

  static Future<String> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    try {
      // Hash the input password for comparison
      var hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Check Firestore for a matching username and password
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: hashedPassword)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('Invalid username or password');
      }

      // Return the user's ID or username
      return userQuery.docs.first.data()['username'];
    } catch (e) {
      print('Error logging in: $e');
      throw Exception('Failed to login');
    }
  }
}
