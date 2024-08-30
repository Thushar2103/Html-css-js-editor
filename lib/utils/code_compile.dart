import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> compile(String html, String css, String js, String fileName,
    Function(String) updateCompiledCode, dynamic webviewController) async {
  String compiledCode = '''
    <html>
      <head>
        <title>Demo</title>
        <style>$css</style> 
        <script>$js</script>
      </head>
      <body>
        $html
      </body>
    </html>
  ''';

  updateCompiledCode(compiledCode);

  // Write updated code to the files
  final directory = await getApplicationDocumentsDirectory();
  final projectDir = Directory('${directory.path}/Tascuit/WebCreate/$fileName');
  if (!projectDir.existsSync()) {
    projectDir.create(recursive: true);
  }

  final htmlFile = File('${projectDir.path}/index.html');
  final cssFile = File('${projectDir.path}/style.css');
  final jsFile = File('${projectDir.path}/script.js');

  await htmlFile.writeAsString(compiledCode);
  await cssFile.writeAsString(css);
  await jsFile.writeAsString(js);

  // Update the webview
  String dataUrl = Uri.dataFromString(compiledCode,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
      .toString();
  webviewController.loadUrl(dataUrl);
}

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
        <title></title>
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
  await jsFile.writeAsString(js);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Files saved successfully in ${projectDir.path}'),
    ),
  );
}
