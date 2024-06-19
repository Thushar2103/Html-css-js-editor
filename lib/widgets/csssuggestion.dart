import 'package:flutter/material.dart';

class CssSuggestion extends StatelessWidget {
  const CssSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textaligncontroller =
        TextEditingController(text: 'text-align: center;');
    TextEditingController colorcontroller =
        TextEditingController(text: 'color: red;');

    TextEditingController fontSizeController =
        TextEditingController(text: 'font-size: 16px;');
    TextEditingController backgroundColorController =
        TextEditingController(text: 'background-color: blue;');
    TextEditingController paddingController =
        TextEditingController(text: 'padding: 10px;');
    TextEditingController marginController =
        TextEditingController(text: 'margin: 20px;');
    return Column(
      children: [
        const Text(
          'Css Suggestion',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: textaligncontroller,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Text Align'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: colorcontroller,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Color'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: fontSizeController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Font Size'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: backgroundColorController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Background Color'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: paddingController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Padding'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: marginController,
          readOnly: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Margin'),
        )
      ],
    );
  }
}
