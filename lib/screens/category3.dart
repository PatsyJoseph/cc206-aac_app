// NEW FILE: category1_page.dart
import 'dart:io';

import 'package:flutter/material.dart';

import '../features/main_page.dart';

class Category3 extends StatelessWidget {
  final List<ButtonItem> buttons;
  final Function(String?) onButtonTap;
  final bool isDeleteMode;
  final Function(int) onToggleSelection;
  final List<AnimationController> animationControllers;

  const Category3({
    Key? key,
    required this.buttons,
    required this.onButtonTap,
    required this.isDeleteMode,
    required this.onToggleSelection,
    required this.animationControllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(10),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (isDeleteMode) {
              onToggleSelection(index);
            } else if (!buttons[index].isPlaceholder) {
              onButtonTap(buttons[index].soundPath);
            }
          },
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.1).animate(
              CurvedAnimation(
                parent: animationControllers[index],
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: buttons[index].isSelected
                    ? Color(0xFFD2D9F5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: buttons[index].isPlaceholder
                    ? Text(
                        buttons[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      )
                    : buttons[index].imagePath != null
                        ? Image.file(File(buttons[index].imagePath!))
                        : Text(
                            buttons[index].text,
                            textAlign: TextAlign.center,
                          ),
              ),
            ),
          ),
        );
      },
    );
  }
}
