// category_view.dart contains the interface, mainly grid view widget used for each category
import 'dart:io';

import 'package:flutter/material.dart';

import 'button_item.dart';

class CategoryView extends StatelessWidget {
  final List<CategoryButtonItem> buttons;
  final String category;
  final Function(int) onButtonPressed;
  final Function(int)? onButtonLongPress;
  final List<AnimationController> animationControllers;
  final bool isDeleteMode;

  const CategoryView({
    Key? key,
    required this.buttons,
    required this.category,
    required this.onButtonPressed,
    this.onButtonLongPress,
    required this.animationControllers,
    required this.isDeleteMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredButtons = category == 'all'
        ? buttons
        : buttons.where((button) => button.category == category).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredButtons.length,
      itemBuilder: (context, index) {
        final button = filteredButtons[index];
        final originalIndex = buttons.indexOf(button);

        return AnimatedBuilder(
          animation: animationControllers[originalIndex],
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + animationControllers[originalIndex].value * 0.1,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => onButtonPressed(originalIndex),
                    onLongPress: onButtonLongPress != null
                        ? () => onButtonLongPress!(originalIndex)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: button.isSelected
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: button.imagePath != null
                            ? Image.file(
                                File(button.imagePath!),
                                fit: BoxFit.cover,
                              )
                            : Text(button.text),
                      ),
                    ),
                  ),
                  if (isDeleteMode && button.isSelected)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFF4D8FF8),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
