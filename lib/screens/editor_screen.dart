import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_css_js/utils/code_compile.dart';
import 'package:html_css_js/utils/layout_switch.dart';
import 'package:html_css_js/widgets/layout1.dart';
import 'package:html_css_js/widgets/layout2.dart';
import 'package:html_css_js/widgets/layout3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pip_view/pip_view.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:html/parser.dart' as html_parser;

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final PageController _pageController = PageController();
  TextEditingController htmlController = TextEditingController();
  TextEditingController cssController = TextEditingController();
  TextEditingController jsController = TextEditingController();
  TextEditingController fileController =
      TextEditingController(text: 'Untitled');
  late WebviewController webviewController;
  String compiledCode = '';
  bool _isDropdownVisible = false;
  bool _isDarkMode = false;
  Widget preview() {
    return Webview(webviewController);
  }

  void handleCodeChange(String newCode) {
    compileCode();
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
    try {
      await webviewController.initialize();
      setState(() {});
    } catch (e) {
      print("Error initializing WebView: $e");
    }
  }

  Future<void> compileCode() async {
    await compile(
      htmlController.text,
      cssController.text,
      jsController.text,
      fileController.text,
      (String compiledCode) {},
      webviewController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
      builder: (context, isFloating) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tascuit'),
              Text(
                'Webcreate',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.layers),
              onPressed: () => switchLayout(0, _pageController),
            ),
            IconButton(
              icon: Icon(Icons.code),
              onPressed: () => switchLayout(1, _pageController),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => switchLayout(2, _pageController),
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepOrangeAccent),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
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
              onPressed: () => saveFile(htmlController.text, cssController.text,
                  jsController.text, fileController.text, context),
            ),
            IconButton(
              icon: const Icon(Icons.folder_open),
              onPressed: openFolder,
            ),
          ],
        ),
        body: PageView(controller: _pageController, children: [
          Layout1(
              htmlController: htmlController,
              codecompile: handleCodeChange,
              cssController: cssController,
              jsController: jsController,
              webviewController: webviewController),
          Layout2(
              htmlController: htmlController,
              codecompile: handleCodeChange,
              cssController: cssController,
              jsController: jsController,
              webviewController: webviewController),
          Layout3(
              htmlController: htmlController,
              codecompile: handleCodeChange,
              cssController: cssController,
              jsController: jsController,
              webviewController: webviewController),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: FloatingActionButton.extended(
              onPressed: () => PIPView.of(context)?.presentBelow(preview()),
              label: const Text('Toggle PIP')),
        ),
      ),
    );
  }

  Future<void> openFolder() async {
    final directory = await getApplicationDocumentsDirectory();
    // final projectDir = Directory('${directory.path}/Tascuit/WebCreate');
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        lockParentWindow: true,
        initialDirectory: '$directory/Tascuit/WebCreate');

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
