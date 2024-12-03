import 'dart:io';

import 'package:flutter/material.dart';

import 'button_item.dart';

class CategoryView extends StatelessWidget {
  final List<CategoryButtonItem> buttons;
  final String category;
  final Function(int) onButtonPressed;
  final List<AnimationController> animationControllers;
  final bool isDeleteMode;

  // Change 1: The parameter onButtonLongPress is now optional and renamed to onButtonLongPressed
  const CategoryView({
    Key? key,
    required this.buttons,
    required this.category,
    required this.onButtonPressed,
    required this.animationControllers,
    required this.isDeleteMode,
    Function(int p1)? onButtonLongPressed, // Optional and renamed parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter buttons based on category
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

        // Ensure we have a valid animation controller index
        final hasValidAnimationController =
            originalIndex >= 0 && originalIndex < animationControllers.length;

        return AnimatedBuilder(
          animation: hasValidAnimationController
              ? animationControllers[originalIndex]
              : const AlwaysStoppedAnimation(0.0),
          builder: (context, child) {
            return Transform.scale(
              scale: hasValidAnimationController
                  ? 1.0 + animationControllers[originalIndex].value * 0.1
                  : 1.0,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isDeleteMode) {
                        button.isSelected = !button
                            .isSelected; // Only toggle for deletion in delete mode
                      }
                      onButtonPressed(
                          originalIndex); // Trigger the main action (e.g., play sound)
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 300), // Optional for smooth transition
                      decoration: BoxDecoration(
                        color: button.isSelected
                            ? Colors
                                .grey.shade200 // Highlight color when selected
                            : Colors.grey.shade200, // Default color
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: button.isSelected
                              ? Colors
                                  .grey.shade300 // Border color when selected
                              : Colors.grey.shade300, // Default border color
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _buildButtonContent(button),
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

  // Change 3: A new method `_handleLongPress` has been added to manage long press logic
  void _handleLongPress(int index) {
    final button = buttons[index];

    if (isDeleteMode) {
      // In delete mode, toggle the selection state
      button.isSelected = !button.isSelected;
    } else {
      // In normal mode, you can implement other long press behavior (e.g., highlighting the button)
      button.isSelected = !button.isSelected;
    }
  }

  Widget _buildButtonContent(CategoryButtonItem button) {
    if (button.imagePath == null) {
      // If there's no image, just display the text
      return Text(
        button.text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    try {
      // Check if the image path is a file path
      if (button.imagePath!.startsWith('/')) {
        final file = File(button.imagePath!);
        if (!file.existsSync()) {
          return _buildErrorWidget(button);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              file,
              fit: BoxFit
                  .contain, // Use BoxFit.contain to scale image proportionally
              height: 110, // Set a fixed height for the image
              errorBuilder: (context, error, stackTrace) =>
                  _buildErrorWidget(button),
            ),
            const SizedBox(height: 8), // Add space between the image and text
            Text(
              button.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      } else {
        // Assume it's an asset image
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              button.imagePath!,
              fit: BoxFit
                  .contain, // Use BoxFit.contain to scale image proportionally
              height: 120, // Set a fixed height for the image
              errorBuilder: (context, error, stackTrace) =>
                  _buildErrorWidget(button),
            ),
            const SizedBox(height: 8), // Add space between the image and text
            Text(
              button.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }
    } catch (e) {
      return _buildErrorWidget(button);
    }
  }

  Widget _buildErrorWidget(CategoryButtonItem button) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          button.text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
