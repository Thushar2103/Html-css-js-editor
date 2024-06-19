// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_css_js/widgets/csssuggestion.dart';
import 'package:html_css_js/widgets/htmlsuggestion.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:pip_view/pip_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _toggleTheme(bool isDark) async {
    if (!kIsWeb) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkMode', isDark);
      setState(() {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      });
    } else {
      setState(() {
        _themeMode = ThemeMode.light;
      });
    }
  }

  Future<void> _loadTheme() async {
    if (!kIsWeb) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
      setState(() {
        _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    } else {
      setState(() {
        _themeMode = ThemeMode.light;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Html Css Js',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        home: CodeCompiler(
            onToggleTheme: _toggleTheme,
            isDarkMode: _themeMode == ThemeMode.light));
  }
}

class CodeCompiler extends StatefulWidget {
  final void Function(bool) onToggleTheme;
  final bool isDarkMode;

  const CodeCompiler(
      {required this.onToggleTheme, required this.isDarkMode, super.key});

  @override
  _CodeCompilerState createState() => _CodeCompilerState();
}

class _CodeCompilerState extends State<CodeCompiler> {
  TextEditingController htmlController = TextEditingController();
  TextEditingController cssController = TextEditingController();
  TextEditingController jsController = TextEditingController();
  TextEditingController fileController =
      TextEditingController(text: 'Untitled');
  late WebviewController webviewController;
  String compiledCode = '';
  bool _isDropdownVisible = false;
  double _sideBoxWidth = 500;
  final double _minSideBoxWidth = 70.0;

  bool _isDarkMode = false;
  // String _appVersion = '';
  double _htmlHeightFraction = 1 / 3;
  double _cssHeightFraction = 1 / 3;
  double _jsHeightFraction = 1 / 3;

  Widget preview() {
    return Webview(webviewController);
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    webviewController = WebviewController();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    await webviewController.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
      builder: (context, isFloating) => Scaffold(
        drawer: Drawer(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: DrawerHeader(
                    child: Text(
                      'Settings',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Theme'),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      widget.onToggleTheme(value);
                    },
                  ),
                ),

                const ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Save Location'),
                  subtitle: Text('Documents'),
                ),
                const Spacer(),
                // const ListTile(
                //   leading: Icon(Icons.info),
                //   title: Text('App Version'),
                //   trailing: Text('1.0'),
                // ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text('CodePencil'),
          actions: [
            Row(
              children: [
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.deepOrangeAccent),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: _toggleDropdown,
                    child: const Text('Snippet Suggest')),
                const SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: fileController,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Name'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: saveFile,
                ),
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: openFolder,
                ),
              ],
            ),
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double totalHeight = constraints.maxHeight;

          double htmlHeight = totalHeight * _htmlHeightFraction;
          double cssHeight = totalHeight * _cssHeightFraction;
          double jsHeight = totalHeight * _jsHeightFraction;

          return Row(
            children: [
              SizedBox(
                width: _sideBoxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Flexible(
                        flex: (_htmlHeightFraction * 1000).toInt(),
                        child: SizedBox(
                          height: htmlHeight,
                          child: TextField(
                            controller: htmlController,
                            decoration: const InputDecoration(
                              labelText: 'HTML',
                              hintText: '<body>Write any tag under</body>',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            maxLines: 20,
                            onChanged: compileCode,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            double delta = details.delta.dy / totalHeight;
                            _htmlHeightFraction =
                                (_htmlHeightFraction + delta).clamp(0.1, 0.8);
                            _cssHeightFraction =
                                (_cssHeightFraction - delta).clamp(0.1, 0.8);
                          });
                        },
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.resizeUpDown,
                          child: Divider(
                            thickness: 2,
                            height: 30,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: (_cssHeightFraction * 1000).toInt(),
                        child: SizedBox(
                          height: cssHeight,
                          child: TextField(
                            controller: cssController,
                            decoration: const InputDecoration(
                              labelText: 'CSS',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            maxLines: 20,
                            onChanged: compileCode,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            double delta = details.delta.dy / totalHeight;
                            _cssHeightFraction =
                                (_cssHeightFraction + delta).clamp(0.1, 0.8);
                            _jsHeightFraction =
                                (_jsHeightFraction - delta).clamp(0.1, 0.8);
                          });
                        },
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.resizeUpDown,
                          child: Divider(
                            thickness: 2,
                            height: 30,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: (_jsHeightFraction * 1000).toInt(),
                        child: SizedBox(
                          height: jsHeight,
                          child: TextField(
                            controller: jsController,
                            decoration: const InputDecoration(
                              labelText: 'JavaScript',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            maxLines: 20,
                            onChanged: compileCode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _sideBoxWidth += details.delta.dx;
                    if (_sideBoxWidth < _minSideBoxWidth) {
                      _sideBoxWidth = _minSideBoxWidth;
                    }
                    if (_sideBoxWidth >
                        constraints.maxWidth - _minSideBoxWidth) {
                      _sideBoxWidth = constraints.maxWidth - _minSideBoxWidth;
                    }
                  });
                },
                child: const MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: VerticalDivider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (!_isDropdownVisible)
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Webview(
                      webviewController,
                    ),
                  ),
                ),
              // Expanded(
              //   child: Webview(
              //     webviewController,
              //   ),
              // ),

              if (_isDropdownVisible)
                Flexible(
                  flex: (_jsHeightFraction * 1000).toInt(),
                  child: Column(
                    children: [
                      Container(
                        height: 280,
                        width: 500,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: const SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: HtmlSuggestion()),
                      ),
                      Container(
                        height: 280,
                        width: 500,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: const SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: CssSuggestion()),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: FloatingActionButton.extended(
              onPressed: () => PIPView.of(context)?.presentBelow(preview()),
              label: const Text('Toggle PIP')),
        ),
      ),
    );
  }

  void compileCode(String? _) {
    String html = htmlController.text;
    String css = cssController.text;
    String js = jsController.text;
    setState(() {
      compiledCode = '''
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
    });

    String dataUrl = Uri.dataFromString(compiledCode,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
    // webviewController.loadUrl(dataUrl);
    webviewController.loadUrl(dataUrl);
  }

  Future<void> saveFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final projectDir = Directory('${directory.path}/${fileController.text}');
    if (!projectDir.existsSync()) {
      await projectDir.create();
    }

    final htmlFile = File('${projectDir.path}/index.html');
    final cssFile = File('${projectDir.path}/style.css');
    final jsFile = File('${projectDir.path}/script.js');

    String html = '''

      <html>
        <head>
          <title></title>
          <link rel="stylesheet" type="text/css" href="style.css">
          <script src="script.js"></script>
        </head>
        <body>
          ${htmlController.text}
        </body>
      </html>
    ''';

    await htmlFile.writeAsString(html);
    await cssFile.writeAsString(cssController.text);
    await jsFile.writeAsString(jsController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Files saved successfully in ${projectDir.path}'),
      ),
    );
  }

  Future<void> openFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      final directory = Directory(selectedDirectory);
      final folderName = path.basename(directory.path); // Extract folder name
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
}
