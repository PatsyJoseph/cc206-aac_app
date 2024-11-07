import 'package:cc206_aac_app/features/aboutUs.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; //added this one

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set MyHomePage as the home widget
      home: AboutUs(),
    );
  }
}
