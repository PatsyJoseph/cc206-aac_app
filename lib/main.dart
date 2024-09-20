import 'package:flutter/material.dart';
import 'package:cc206_aac_app/features/homepage.dart';  // Correctly imports your homepage.dart file

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
      home: const MyHomePage(),
    );
  }
}
