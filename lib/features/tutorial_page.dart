import 'package:flutter/material.dart';

/// A tutorial page with swipeable onboarding screens.
class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of tutorial data (title, description, and icon).
    final List<Map<String, dynamic>> tutorials = [
      {
        'title': 'Title Card 1',
        'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac orci mollis, dictum nisi sit amet, fringilla dui.',
        'icon': Icons.add,
      },
      {
        'title': 'Title Card 2',
        'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac orci mollis, dictum nisi sit amet, fringilla dui.',
        'icon': Icons.add,
      },
      {
        'title': 'Title Card 3',
        'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac orci mollis, dictum nisi sit amet, fringilla dui.',
        'icon': Icons.add,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Title and description section at the top
                  const SizedBox(height: 40),
                  const Text(
                    'Tutorial', // Main heading
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D8FF8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Swipe through the tutorial to get started.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Expanded PageView for swipeable tutorial screens
                  Expanded(
                    child: PageView.builder(
                      itemCount: tutorials.length,
                      itemBuilder: (context, index) {
                        final tutorial = tutorials[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Circle icon illustration
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                tutorial['icon'], // Directly pass the icon data
                                size: 72,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Title
                            Text(
                              tutorial['title']!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Description
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                tutorial['description']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Circular return button at the bottom right
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4D8FF8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ), // Back arrow icon
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to previous screen
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
