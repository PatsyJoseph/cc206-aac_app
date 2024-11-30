import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _currentUser;

  String? get currentUser => _currentUser;

  // get username => null;

  void setCurrentUser(String user) {
    _currentUser = user;
    notifyListeners();
  }
}
