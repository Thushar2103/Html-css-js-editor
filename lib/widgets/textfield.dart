import 'package:flutter/material.dart';

Widget textfield(TextEditingController textcontroller, String labelname,
    void Function(String) codecompile) {
  return Container(
    color: Colors.black26,
    child: TextField(
      scribbleEnabled: true,
      controller: textcontroller,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontWeight: FontWeight.w900),
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
