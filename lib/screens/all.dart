import 'package:flutter/material.dart';

// Define a ButtonItem model
class ButtonItem {
  String text;
  String imagePath;
  bool isSelected;
  String category; // To track which category the button belongs to

  ButtonItem({
    required this.text,
    required this.imagePath,
    this.isSelected = false,
    required this.category,
  });
}

class All extends StatefulWidget {
  final List<ButtonItem>
      buttons; // List of all buttons passed from the parent widget

  All({Key? key, required this.buttons}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  bool isDeleteMode = false;

  // Function to toggle selection mode
  void _toggleSelection(int index) {
    setState(() {
      widget.buttons[index].isSelected = !widget.buttons[index].isSelected;
    });
  }

  // Function to delete selected buttons
  void _deleteSelectedButtons() {
    setState(() {
      widget.buttons.removeWhere((button) => button.isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Items'),
        actions: [
          if (isDeleteMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedButtons,
            ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.buttons.length,
        itemBuilder: (context, index) {
          final button = widget.buttons[index];
          return GestureDetector(
            onTap: () {
              if (isDeleteMode) {
                _toggleSelection(index);
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: button.isSelected ? Colors.red.withOpacity(0.5) : null,
              ),
              child: Column(
                children: [
                  button.imagePath.isNotEmpty
                      ? Image.asset(
                          button.imagePath) // Display image from the path
                      : Container(),
                  Text(button.text),
                  Text(
                      'Category: ${button.category}'), // Display the category of the button
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDeleteMode = !isDeleteMode; // Toggle delete mode
          });
        },
        child: Icon(isDeleteMode ? Icons.cancel : Icons.delete),
      ),
    );
  }
}
