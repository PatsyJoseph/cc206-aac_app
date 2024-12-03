import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> _pages = [
    const Ulalayaw(),
    const Team(),
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth > 400 ? 16.0 : 12.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: fontSize + 8, // Slightly larger for title
                          fontWeight: FontWeight.bold,
                          color: const Color(
                              0xFF4D8FF8), // Blue color for the title
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learn More About Tinig',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 151, 151, 151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Swipe to meet our contributors.',
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Linear Progress Indicator
                  LinearProgressIndicator(
                    value: (_currentPage + 1) / _pages.length,
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFF4D8FF8),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: _pages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index % _pages.length];
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

class Ulalayaw extends StatelessWidget {
  const Ulalayaw({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth > 400 ? 16.0 : 12.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/officiallogo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 15),
            Text(
              "Tnig is a Project Based Alternative and Augmentative Communication (AAC) Application centered around the Filipino Language, created by 3rd Year Computer Science students of West Visayas State University. The Concept of Ulalayaw came from the Word's meaning, which refers to being in a state of closeness to a person, and provides support and companionship to said person",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth > 400 ? 16.0 : 10.0;

    final teamMembers = [
      {
        'name': 'Patrick Joseph Napud',
        'email': 'patrickjoseph.napud@wvsu.edu.ph',
        'role': 'Project Manager',
        'image': 'assets/about_page/Patrick.JPG'
      },
      {
        'name': 'Jill Navarra',
        'email': 'jill.navarra@wvsu.edu.ph',
        'role': 'Backend Developer',
        'image': 'assets/about_page/Jill.jpg'
      },
      {
        'name': 'Pauline Joy Bautista',
        'email': 'paulinejoy.bautista@wvsu.edu.ph',
        'role': 'Head Developer',
        'image': 'assets/about_page/Pauline.JPG'
      },
      {
        'name': 'Ashley Denise Feliciano',
        'email': 'ashleydenise.feliciano@wvsu.edu.ph',
        'role': 'QA Engineer',
        'image': 'assets/about_page/Ash.JPG'
      },
      {
        'name': 'Joshua Prinze C. Calibjo',
        'email': 'joshuaprinze.calibjo@wvsu.edu.ph',
        'role': 'Marketing Specialist',
        'image': 'assets/about_page/Joshua.JPG'
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Meet The Team',
            style:
                TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: teamMembers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final member = teamMembers[index];
              return Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(member['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    member['name']!,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    member['email']!,
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    member['role']!,
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
