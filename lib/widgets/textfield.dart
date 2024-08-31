import 'package:flutter/material.dart';

Widget textfield(TextEditingController textcontroller, String labelname,
    void Function(String) codecompile) {
  return Container(
    color: Colors.black26,
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: TextField(
      scribbleEnabled: true,
      controller: textcontroller,
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontWeight: FontWeight.w900),
        labelText: labelname,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
      ),
      maxLines: 30,
      onChanged: codecompile,
    ),
  );
}
