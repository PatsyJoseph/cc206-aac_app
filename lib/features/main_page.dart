import 'package:cc206_aac_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MaterialApp: Root widget of the application, provides basic app configuration
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAC App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _isFormVisible = false;

  List<Map<String, dynamic>> _buttons = [
    {'label': 'Button 1', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 2', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 3', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 4', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 5', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 6', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 7', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 8', 'image': 'assets/images/avatar1.png'},
    {'label': 'Button 9', 'image': 'assets/images/avatar1.png'},
  ];
  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
  }

  void _addButton() {
    final name = _nameController.text;
    final image = _imageController.text;
    if (name.isNotEmpty) {
      setState(() {
        _buttons.add({
          'label': name,
          'image': image.isNotEmpty ? image : null,
        });
      });
      _nameController.clear();
      _imageController.clear();
      _toggleFormVisibility();
    }
  }

  void _deleteLastButton() {
    if (_buttons.isNotEmpty) {
      setState(() {
        _buttons.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: Provides basic app structure with app bar and body
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: const Text(
          'Main Page',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFC4DAD2),
      ),
      // Padding: Adds padding around its child
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Column: Arranges its children in a vertical array
        child: Column(
          children: [
            // Row: Arranges its children in a horizontal array
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _toggleFormVisibility,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text(
                      'Add New',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                // SizedBox: Creates an empty space with specified dimensions
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteLastButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_isFormVisible) ...[
              // Table: Arranges its children in rows and columns
              Table(
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Enter Title:',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter button label',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text('Add Image:', style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _imageController,
                          decoration: InputDecoration(
                            hintText: 'Enter image path (optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Center: Centers its child within itself
              Center(
                child: ElevatedButton(
                  onPressed: _addButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Spacer: Creates an adjustable empty space
              const Spacer(),
            ],
            // Expanded: Expands to fill available space
            Expanded(
              // GridView: Displays children in a scrollable, 2D array
              child: GridView.builder(
                itemCount: _buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final button = _buttons[index];
                  final buttonLabel = button['label'];
                  final buttonImage = button['image'];

                  // Container: A convenience widget that combines common painting, positioning, and sizing widgets
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print('$buttonLabel pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (buttonImage != null)
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth * 0.8,
                                      maxHeight: constraints.maxHeight * 0.6,
                                    ),
                                    child: Image.asset(
                                      buttonImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    buttonLabel,
                                    style: const TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
