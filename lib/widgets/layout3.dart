import 'package:flutter/material.dart';
import 'package:html_css_js/widgets/textfield.dart';
import 'package:webview_windows/webview_windows.dart';

class Layout3 extends StatefulWidget {
  final TextEditingController htmlController;
  final TextEditingController cssController;
  final TextEditingController jsController;
  final void Function(String) codecompile;
  final WebviewController webviewController;
  const Layout3(
      {super.key,
      required this.htmlController,
      required this.codecompile,
      required this.cssController,
      required this.jsController,
      required this.webviewController});

  @override
  State<Layout3> createState() => _Layout3State();
}

class _Layout3State extends State<Layout3> {
  double _sideBoxHeight = 200;
  final double _minSideBoxHeight = 70.0;

  double _htmlWidthFraction = 1 / 3;
  double _cssWidthFraction = 1 / 3;
  double _jsWidthFraction = 1 / 3;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(tabs: [
            Tab(
              text: 'HTML',
            ),
            Tab(
              text: 'CSS',
            ),
            Tab(
              text: 'JavaScript',
            )
          ]),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double totalWidth = constraints.maxWidth;

          double htmlWidth = totalWidth * _htmlWidthFraction;
          double cssWidth = totalWidth * _cssWidthFraction;
          double jsWidth = totalWidth * _jsWidthFraction;

          return Column(children: [
            SizedBox(
              height: _sideBoxHeight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TabBarView(
                  children: [
                    SizedBox(
                        // height: htmlHeight,
                        child: textfield(
                            widget.htmlController, 'HTML', widget.codecompile)),
                    SizedBox(
                        // height: htmlHeight,
                        child: textfield(
                            widget.cssController, 'CSS', widget.codecompile)),
                    SizedBox(
                        // height: htmlHeight,
                        child: textfield(widget.jsController, 'Javascript',
                            widget.codecompile)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _sideBoxHeight += details.delta.dy;
                  if (_sideBoxHeight < _minSideBoxHeight) {
                    _sideBoxHeight = _minSideBoxHeight;
                  }
                  if (_sideBoxHeight >
                      constraints.maxHeight - _minSideBoxHeight) {
                    _sideBoxHeight = constraints.maxHeight - _minSideBoxHeight;
                  }
                });
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 2,
                ),
              ),
            ),
            // if (!_isDropdownVisible)
            Flexible(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Webview(
                  widget.webviewController,
                ),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
