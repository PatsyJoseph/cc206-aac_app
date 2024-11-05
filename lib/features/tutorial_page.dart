import 'package:flutter/material.dart';

/// TutorialPage widget displays a tutorial section with a title, description,
/// and a list of tutorial items. It includes a circular return button to navigate back.
class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              child: ListView(
                children: [
                  // Title section
                  Text(
                    'Tutorial', // Title text
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D8FF8),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description', // Description text
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24),
                  // Generate a list of tutorial items
                  ...List.generate(4, (index) {
                    return Column(
                      children: [
                        // Individual tutorial item
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline, // Icon for tutorial item
                              size: 32,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Title', // Title for the tutorial item
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Body text for whatever you’d like to say. Add main takeaway points, quotes, anecdotes, or even a very very short story.', // Body text for the tutorial item
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          // Circular return button on the bottom right
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4D8FF8),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white), // Back arrow icon
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
}