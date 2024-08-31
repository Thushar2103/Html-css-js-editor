import 'dart:convert';
import 'dart:io';
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
