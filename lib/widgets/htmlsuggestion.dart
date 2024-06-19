import 'package:flutter/material.dart';

class HtmlSuggestion extends StatelessWidget {
  const HtmlSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController h1controller =
        TextEditingController(text: '<h1>h1</h1>');
    TextEditingController pcontroller = TextEditingController(
        text: '<p>A Computer Science Portal for Geeks</p>');
    TextEditingController divController =
        TextEditingController(text: '<div>Content</div>');
    TextEditingController imgController = TextEditingController(
        text:
            '<img src="https://images.pexels.com/photos/213780/pexels-photo-213780.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500" alt="Image">');
    TextEditingController aController = TextEditingController(
        text: '<a href="https://www.google.com">Link</a>');
    return Column(
      children: [
        const Text(
          'Html Suggestion',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: h1controller,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'h1 tag'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: pcontroller,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'p tag'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: divController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'div tag'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: imgController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'img tag'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: aController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'a tag'),
        )
      ],
    );
  }
}
