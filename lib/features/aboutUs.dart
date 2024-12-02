import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AboutUs(), // Set AboutPage as the home screen
      debugShowCheckedModeBanner: false,
    );
  }
}

/// AboutPage widget displays information about the app and its team,
/// including sections for 'About Us' and 'Meet the Team'.
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
                    ],
                  ),
                 const Text(
                    'About Us',
                    style: TextStyle(
                    fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                const Text(
                  'Learn More About Ulalayaw',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 151, 151, 151),
                  ),
                 ),
                  const SizedBox(height: 8),
                  Text(
                    'Swipe to meet our contributors.',
                    style: TextStyle(
                      fontSize: 16,
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

                Expanded (
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
                    }
                  )
                )    
              ]
                
              ),
            
          )
        ),
        ],
      )
    );
  }
 }

class Ulalayaw extends StatelessWidget {
  const Ulalayaw({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 15),
              const Text(
                "Ulalayaw is a Project Based Alternative and Augmentative Communication (AAC) Application centered around the Filipino Language, created by 3rd Year Computer Science students of West Visayas State University. The Concept of Ulalayaw came from the Word's meaning, which refers to being in a state of closeness to a person, and provides support and companionship to said person",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key});
  

  @override
  Widget build(BuildContext context) {
     final teamMembers = [
      {
        'name': 'Patrick Joseph Napud',
        'email': 'patrickjoseph.napud@wvsu.edu.ph',
        'role': 'Project Manager',
        'image': 'assets/Patrick.jpg'
      },
      {
        'name': 'Jill Navarra',
        'email': 'jill.navarra@wvsu.edu.ph',
        'role': 'UI/UX Designer',
        'image': 'assets/Jill.jpg'
      },
      {
        'name': 'Pauline Joy Bautista',
        'email': 'paulinejoy.bautista@wvsu.edu.ph',
        'role': 'Head Developer',
        'image': 'assets/Pauline.jpg'
      },
      {
        'name': 'Ashley Denise Feliciano',
        'email': 'ashleydenise.feliciano@wvsu.edu.ph',
        'role': 'QA Engineer',
        'image': 'assets/Ash.jpg'
      },
      {
        'name': 'Joshua Prinze C. Calibjo',
        'email': 'joshuaprinze.calibjo@wvsu.edu.ph',
        'role': 'Marketing Specialist',
        'image': 'assets/Joshua.jpg'
      },
    ];

    // Extract data for the current team member
     
   return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
          child: Text(
            'Meet The Team',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      Expanded(child: GridView.builder(
      itemCount: teamMembers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
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
              image: AssetImage(member['image']!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),

        // Name
      SizedBox(height: 5),
      Align(
        alignment: Alignment.center,  
        child: Text(
          member['name']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),

        // Email
        SizedBox(height: 5),
        Align (
          alignment: Alignment.center,
          child: Text(
          member['email']!,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        ),

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
      },
    )
      )
    ],
   );
    
  }
}
