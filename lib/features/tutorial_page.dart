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
        'title': 'Title Card 1',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac orci mollis, dictum nisi sit amet, fringilla dui.',
        'icon': Icons.add,
      },
      {
        'title': 'Title Card 2',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac orci mollis, dictum nisi sit amet, fringilla dui.',
        'icon': Icons.add,
      },
      {
        'title': 'Title Card 3',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ac orci mollis, dictum nisi sit amet, fringilla dui.',
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
                  const SizedBox(height: 40),
                  const Text(
                    'Tutorial',
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

                  // Linear Progress Indicator to show progress
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
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                tutorial['icon'],
                                size: 72,
                                color: Colors.grey[800],
                              ),
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
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
