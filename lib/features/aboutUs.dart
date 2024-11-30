import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AboutUs(), // Set AboutPage as the home screen
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

/// AboutPage widget displays information about the app and its team,
/// including sections for 'About Us' and 'Meet the Team'.
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // About Us Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 80),
                    color: Color(0xFF4D8FF8), // Blue background
                    child: Column(
                      children: [
                        Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: DefaultTextStyle(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                child: AnimatedTextKit(
                                    repeatForever: true,
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      FadeAnimatedText(
                                        'Ulalayaw is an AAC designed and built for Filipinos. By Filipinos, with a major focus on native and local languages',
                                      ),
                                      FadeAnimatedText(
                                        'Ang Ulalayaw ay isang AAC app na inilikha ng Filipino para sa mga kapwa Filipino, na nakatingin sa ating sariling wika ',
                                      ),
                                    ]))),
                      ],
                    ),
                  ),

                  // Meet the Team Section
                  SizedBox(height: 40),
                  Text(
                    "Meet the Team", // Changed from "The Team" to "Meet the Team"
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D8FF8),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Team Members as Grid with 2 items per row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 5, // Number of team members
                      itemBuilder: (context, index) {
                        return _buildTeamMember(index);
                      },
                    ),
                  ),

                  SizedBox(height: 40),

                  // Footer Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at ultricies ex.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // Add extra padding at the bottom to ensure the floating button doesn't obscure content
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Circular Return Button on Right
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4D8FF8),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Navigate back to the previous screen
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper function to create team member widgets with images and details.
  Widget _buildTeamMember(int index) {
    // Dummy data for team members
    final teamMembers = [
      {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'role': 'Project Manager'
      },
      {
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'role': 'Lead Developer'
      },
      {
        'name': 'Alice Johnson',
        'email': 'alice.johnson@example.com',
        'role': 'UI/UX Designer'
      },
      {
        'name': 'Bob Brown',
        'email': 'bob.brown@example.com',
        'role': 'QA Engineer'
      },
      {
        'name': 'Charlie Green',
        'email': 'charlie.green@example.com',
        'role': 'Marketing Specialist'
      },
    ];

    // Extract data for the current team member
    final member = teamMembers[index];

    return Column(
      children: [
        // Circle Avatar with Image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/about_page/trial.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),

        // Name
        Text(
          member['name']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),

        // Email
        Text(
          member['email']!,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 5),

        // Role
        Text(
          member['role']!,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
