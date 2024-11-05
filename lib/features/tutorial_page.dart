import 'package:flutter/material.dart';

/// A tutorial page with swipeable onboarding screens.
class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // List of tutorial data (title, description, and icon).
    final List<Map<String, dynamic>> tutorials = [
      {
        'title': 'Hear it!',
        'description':
            'Tap the button to play your recorded audio sounds. It allows you to communicate effectively by hearing your personalized audio cues, helping you express yourself with confidence.',
        'icon': 'assets/images/tCard1.png',
      },
      {
        'title': 'Add your voice!',
        'description':
            'Use the "Add New" button to add your own custom sounds. Personalize your communication by adding your unique expressions, making it easier to convey your thoughts and feelings.',
        'icon': 'assets/images/tCard2.png',
      },
      {
        'title': 'Feel free to delete!',
        'description':
            'Easily manage your sounds with the delete feature. Remove any audio you no longer need, ensuring your communication board stays relevant and up-to-date.',
        'icon': 'assets/images/tCard3.png',
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
                  const SizedBox(height: 40),
                  // Row for title and back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF4D8FF8),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'How to Use Ulayaw?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4D8FF8),
                        ),
                      ),
                    ],
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

                  // Linear Progress Indicator
                  LinearProgressIndicator(
                    value: (_currentPage + 1) / tutorials.length,
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFF4D8FF8),
                  ),
                  const SizedBox(height: 16),

                  // Expanded PageView for swipeable tutorial screens
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: tutorials.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final tutorial = tutorials[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              tutorial['icon'],
                              width: 300, // Width
                              height: 300, // Height
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              tutorial['title']!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
        ],
      ),
    );
  }
}
