// user_provider.dart is a reusable code that sets the current user after logging
// in. It can be passed through different codes needed.

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
