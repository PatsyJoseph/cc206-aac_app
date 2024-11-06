import 'package:flutter/material.dart';

// Define a ButtonItem model
class ButtonItem {
  String text;
  String imagePath;
  bool isSelected;

  ButtonItem({
    required this.text,
    required this.imagePath,
    this.isSelected = false,
  });
}

class Category1 extends StatefulWidget {
  @override
  _Category1State createState() => _Category1State();
}

class _Category1State extends State<Category1> {
  // Initial empty list of buttons
  List<ButtonItem> buttons = [];
  bool isDeleteMode = false;

  // Function to toggle selection mode
  void _toggleSelection(int index) {
    setState(() {
      buttons[index].isSelected = !buttons[index].isSelected;
    });
  }

  // Function to delete selected buttons
  void _deleteSelectedButtons() {
    setState(() {
      buttons.removeWhere((button) => button.isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final button = buttons[index];
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
                      ? Image.asset(button.imagePath)
                      : Container(),
                  Text(button.text),
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
