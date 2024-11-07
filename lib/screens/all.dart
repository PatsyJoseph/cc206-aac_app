// all.dart to display compilation of all buttons from the 3 categories

import 'package:flutter/material.dart';

import 'button_item.dart';
import 'category_view.dart';

class All extends StatelessWidget {
  final List<CategoryButtonItem> buttons;
  final Function(int) onButtonPressed;
  final Function(int)? onButtonLongPress;
  final List<AnimationController> animationControllers;
  final bool isDeleteMode;

  const All({
    Key? key,
    required this.buttons,
    required this.onButtonPressed,
    this.onButtonLongPress,
    required this.animationControllers,
    required this.isDeleteMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryView(
      buttons: buttons,
      category: 'all',
      onButtonPressed: onButtonPressed,
      onButtonLongPress: onButtonLongPress,
      animationControllers: animationControllers,
      isDeleteMode: isDeleteMode,
    );
  }
}
