import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:html/parser.dart' as html_parser;

Future<void> openFolder(
    BuildContext context,
    TextEditingController fileController,
    TextEditingController htmlController,
    TextEditingController cssController,
    TextEditingController jsController) async {
  final directory = await getApplicationDocumentsDirectory();
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      lockParentWindow: true, initialDirectory: '$directory/Tascuit/WebCreate');

  if (selectedDirectory != null) {
    final directory = Directory(selectedDirectory);
    final folderName = path.basename(directory.path);
    fileController.text = folderName;

    final files = directory.listSync();

    for (var file in files) {
      if (file is File) {
        final fileType = path.extension(file.path).toLowerCase();
        final fileContent = await file.readAsString();

        if (fileType == '.html') {
          final document = html_parser.parse(fileContent);
          final bodyContent = document.body?.innerHtml ?? '';
          htmlController.text = bodyContent;
        } else if (fileType == '.css') {
          cssController.text = fileContent;
        } else if (fileType == '.js') {
          jsController.text = fileContent;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Files opened successfully'),
      ),
    );
  }
}
