import 'dart:io';

import 'package:Ulayaw/firebase/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  final String currentUser;

  // const UserProfilePage({
  //   required this.username, // Initialize username
  // });

  UserProfilePage({required this.currentUser, required String password});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? _profileImagePath;

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get the application's documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a unique path for the saved image
      final savedImagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      // Save the picked image to the local directory
      final savedImage = await File(pickedFile.path).copy(savedImagePath);

      // Save the path in the state
      setState(() {
        _profileImagePath = savedImage.path;
      });

      // Persist the image path in SharedPreferences
      await saveProfileImagePath(savedImage.path);
    }
  }

  Future<void> saveProfileImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', imagePath);
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImagePath();
  }

  Future<void> _loadProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath =
          prefs.getString('profileImagePath'); // Retrieve saved path
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserProvider>().currentUser;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.0),

              // Profile Picture Display (centered)
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Allow user to upload a new photo
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: _profileImagePath != null
                        ? FileImage(File(_profileImagePath!))
                        : AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                    child: _profileImagePath == null
                        ? Icon(Icons.camera_alt, size: 30.0)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              // Label under profile image
              Text(
                'Click profile pic to replace image',
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20.0),

              // Welcome message with username
              Text(
                'Welcome, $username!',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),

              // New message about Ulayaw's unique features
              Text(
                'Through this application, we aim to help enhance communication and independence, '
                'particularly for those who speak Filipino. By providing tools that support better social interaction, '
                'we hope to increase confidence, assist caregivers, and make communication easier, especially during emergencies.',
                style: TextStyle(fontSize: 16.0, height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),

              // Email Address (no links)
              Text(
                'For suggestions and improvements, you can email us at:\n'
                'tinigaacapplication@gmail.com',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
