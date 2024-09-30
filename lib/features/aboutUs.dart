import 'package:flutter/material.dart';

void main() {
  runApp(AboutUsPage());
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Our Company',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'We strive to deliver the best services to our customers by combining innovative technology with excellent customer service.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.code, color: Colors.blueAccent, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Innovative Solutions',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.people, color: Colors.blueAccent, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Customer Focused',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.verified, color: Colors.blueAccent, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Quality Assurance',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'To be a leader in innovation while maintaining a customer-centric approach, ensuring high quality in every aspect of our service.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  '© 2024 Our Company, All rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
