import 'package:flutter/material.dart';

void _switchLayout(int index, PageController pageController) {
  pageController.animateToPage(index,
      duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
}
