// category2.dart for interface of category 2 buttons
import 'package:flutter/material.dart';

import 'button_item.dart';
import 'category_view.dart';

class Category2 extends StatelessWidget {
  final List<CategoryButtonItem> buttons;
  final Function(int) onButtonPressed;
  final Function(int)? onButtonLongPress;
  final List<AnimationController> animationControllers;
  final bool isDeleteMode;

  const Category2({
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
      category: 'category2',
      onButtonPressed: onButtonPressed,
      onButtonLongPress: onButtonLongPress,
      animationControllers: animationControllers,
      isDeleteMode: isDeleteMode,
    );
  }
}
