import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String searchQuery = ''; // To hold the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Home"),
            Text("About Us"),
          ],
        ),
        backgroundColor: const Color(0xFF6256CA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search form
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // Update the search query
                });
              },
            ),
            const SizedBox(
                height: 16), // Space between the search bar and GridView
            // Grid of buttons
            Expanded(
              child: GridView.builder(
                itemCount: 18, // Adjust the number of buttons as needed
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of buttons per row
                  crossAxisSpacing: 15, // Spacing between buttons horizontally
                  mainAxisSpacing: 20, // Spacing between buttons vertically
                  childAspectRatio:
                      1.1, // Aspect ratio of the child (width/height)
                ),
                itemBuilder: (context, index) {
                  final buttonLabel =
                      'Button ${index + 1}'; // Label for each button

                  // Only show buttons that match the search query
                  if (searchQuery.isNotEmpty &&
                      !buttonLabel.toLowerCase().contains(searchQuery)) {
                    return const SizedBox.shrink(); // Hide non-matching items
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 248, 255),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // How much the shadow spreads
                          blurRadius: 3, // How blurry the shadow is
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          () {}, // Define the action for the button press
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        elevation: 0, // Remove default shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Center(
                        // Add image to the first button, text for others
                        child: index == 0
                            ? Image.asset(
                                'assets/images/tw.jpg') // Image for button 1
                            : Text(
                                buttonLabel), // Button label for other buttons
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
