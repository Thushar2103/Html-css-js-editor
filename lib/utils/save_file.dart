import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFile(String html, String css, String js, String fileName,
    BuildContext context) async {
  final directory = await getApplicationDocumentsDirectory();
  final projectDir = Directory('${directory.path}/Tascuit/WebCreate/$fileName');
  if (!projectDir.existsSync()) {
    await projectDir.create(recursive: true);
  }

  final htmlFile = File('${projectDir.path}/index.html');
  final cssFile = File('${projectDir.path}/style.css');
  final jsFile = File('${projectDir.path}/script.js');

  String htmlContent = '''
    <html>
      <head>
        <title>$fileName</title>
        <link rel="stylesheet" type="text/css" href="style.css">
        <script src="script.js"></script>
      </head>
      <body>
        $html
      </body>
    </html>
  ''';

  await htmlFile.writeAsString(htmlContent);
  await cssFile.writeAsString(css);
  if (js == '') {
    return;
  } else {
    await jsFile.writeAsString(js);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Files saved successfully in ${projectDir.path}'),
    ),
  );
}
