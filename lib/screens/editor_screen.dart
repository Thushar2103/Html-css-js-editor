import 'package:flutter/material.dart';
import 'package:html_css_js/utils/code_compile.dart';
import 'package:html_css_js/utils/layout_switch.dart';
import 'package:html_css_js/utils/open_file.dart';
import 'package:html_css_js/utils/save_file.dart';
import 'package:html_css_js/widgets/layout1.dart';
import 'package:html_css_js/widgets/layout2.dart';
import 'package:html_css_js/widgets/layout3.dart';
import 'package:pip_view/pip_view.dart';
import 'package:webview_windows/webview_windows.dart';

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
  // bool _isDarkMode = false;
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
          title: const Column(
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
              icon: const Icon(Icons.layers),
              onPressed: () => switchLayout(0, _pageController),
            ),
            IconButton(
              icon: const Icon(Icons.code),
              onPressed: () => switchLayout(1, _pageController),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
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
                onPressed: () => openFolder(context, fileController,
                    htmlController, cssController, jsController)),
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
        floatingActionButton: IconButton.filled(
            iconSize: 30,
            onPressed: () {},
            icon: const Icon(Icons.remove_red_eye_rounded)),
      ),
    );
  }
}
