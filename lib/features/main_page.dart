import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: This widget is the root of the application,
    // providing theming, navigation, and routing features.
    return MaterialApp(
      title: 'Dynamic Button Grid',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MainPage(),
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

  // Initial list of buttons with default labels and optional images.
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
      _isFormVisible =
          !_isFormVisible; // Toggles the visibility of the input form.
    });
  }

  void _addButton() {
    final name = _nameController.text;
    final image = _imageController.text;
    if (name.isNotEmpty) {
      setState(() {
        // Adds a new button to the list with a label and optional image path.
        _buttons.add({
          'label': name,
          'image': image.isNotEmpty ? image : null,
        });
      });
      _nameController.clear(); // Clears the name input field.
      _imageController.clear(); // Clears the image input field.
      _toggleFormVisibility(); // Hides the form after submission.
    }
  }

  void _deleteLastButton() {
    if (_buttons.isNotEmpty) {
      setState(() {
        // Removes the last button from the list.
        _buttons.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: const Text(
          'Main Page',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFC4DAD2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Padding: Adds space around the content.
        child: Column(
          children: [
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
                const SizedBox(
                    width:
                        10), // SizedBox: Provides horizontal spacing between buttons.
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
            const SizedBox(
                height:
                    10), // SizedBox: Provides vertical spacing between widgets.
            if (_isFormVisible) ...[
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(120), // Fixed width for the labels.
                  1: FlexColumnWidth(), // Flexible width for inputs.
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text('Enter Title:',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0), // Added left padding for aesthetics.
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text('Add Image:',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0), // Added left padding for aesthetics.
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
              const SizedBox(
                  height: 8), // SizedBox: Provides spacing below the form.
              ElevatedButton(
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
              const SizedBox(
                  height:
                      20), // SizedBox: Provides spacing below the form before Spacer.
              const Spacer(), // Spacer: Pushes the GridView down to create space for the form.
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom:
                        20.0), // Padding: Adds space at the bottom of the GridView.
                // GridView: Displays dynamic buttons in a grid format, adapting to the number of buttons.
                child: GridView.builder(
                  itemCount: _buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns in the grid.
                    crossAxisSpacing: 15, // Spacing between columns.
                    mainAxisSpacing: 15, // Spacing between rows.
                    childAspectRatio: 1.0, // Aspect ratio of each child.
                  ),
                  itemBuilder: (context, index) {
                    final button = _buttons[index];
                    final buttonLabel = button['label'];
                    final buttonImage = button['image'];

                    return Container(
                      padding: const EdgeInsets.all(
                          8.0), // Padding around each button.
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                              '$buttonLabel pressed'); // Action when button is pressed.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (buttonImage != null)
                              Image.asset(
                                buttonImage,
                                height:
                                    MediaQuery.of(context).size.width / 3 * 0.7,
                                width:
                                    MediaQuery.of(context).size.width / 3 * 0.7,
                              ),
                            const SizedBox(
                                height:
                                    8), // SizedBox: Provides spacing between image and label.
                            Text(buttonLabel,
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
