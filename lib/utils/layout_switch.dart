import 'package:flutter/material.dart';

void switchLayout(int index, PageController pageController) {
  pageController.animateToPage(index,
      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
}
