import 'package:flutter/material.dart';
import 'package:html_css_js/widgets/textfield.dart';
import 'package:webview_windows/webview_windows.dart';

class Layout2 extends StatefulWidget {
  final TextEditingController htmlController;
  final TextEditingController cssController;
  final TextEditingController jsController;
  final void Function(String) codecompile;
  final WebviewController webviewController;
  const Layout2(
      {super.key,
      required this.htmlController,
      required this.codecompile,
      required this.cssController,
      required this.jsController,
      required this.webviewController});

  @override
  State<Layout2> createState() => _Layout2State();
}

class _Layout2State extends State<Layout2> {
  double _sideBoxHeight = 200;
  final double _minSideBoxHeight = 70.0;

  double _htmlWidthFraction = 1 / 3;
  double _cssWidthFraction = 1 / 3;
  double _jsWidthFraction = 1 / 3;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
            child: Row(
              children: [
                Flexible(
                  flex: (_htmlWidthFraction * 1000).toInt(),
                  child: SizedBox(
                      width: htmlWidth,
                      child: textfield(
                          widget.htmlController, 'HTML', widget.codecompile)),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      double delta = details.delta.dx / totalWidth;
                      _htmlWidthFraction =
                          (_htmlWidthFraction + delta).clamp(0.1, 0.8);
                      _cssWidthFraction =
                          (_cssWidthFraction - delta).clamp(0.1, 0.8);
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
                Flexible(
                  flex: (_cssWidthFraction * 1000).toInt(),
                  child: SizedBox(
                      width: cssWidth,
                      child: textfield(
                          widget.cssController, 'CSS', widget.codecompile)),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      double delta = details.delta.dx / totalWidth;
                      _cssWidthFraction =
                          (_cssWidthFraction + delta).clamp(0.1, 0.8);
                      _jsWidthFraction =
                          (_jsWidthFraction - delta).clamp(0.1, 0.8);
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
                Flexible(
                  flex: (_jsWidthFraction * 1000).toInt(),
                  child: SizedBox(
                    width: jsWidth,
                    child: textfield(
                        widget.jsController, 'JavaScript', widget.codecompile),
                  ),
                ),
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
              if (_sideBoxHeight > constraints.maxHeight - _minSideBoxHeight) {
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
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Webview(
              widget.webviewController,
            ),
          ),
        ),
      ]);
    });
  }
}
