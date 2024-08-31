import 'package:flutter/material.dart';
import 'package:html_css_js/utils/layout_switch.dart';

void settings(BuildContext context, PageController pageController) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const BeveledRectangleBorder(),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filled(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.navigate_before)),
            const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        content: SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                dense: true,
                title: Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Dark/Light'),
              ),
              ListTile(
                dense: true,
                title: const Text(
                  'Layout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text('1'),
                      onPressed: () => switchLayout(0, pageController),
                    ),
                    TextButton(
                      child: const Text('2'),
                      onPressed: () => switchLayout(1, pageController),
                    ),
                    TextButton(
                      child: const Text('3'),
                      onPressed: () => switchLayout(2, pageController),
                    ),
                    TextButton(
                      child: const Text('4'),
                      onPressed: () => switchLayout(3, pageController),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Center(
                child: Text(
                  "Developed By",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  "Tascuit",
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
