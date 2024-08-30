import 'package:flutter/material.dart';
import 'package:html_css_js/widgets/textfield.dart';
import 'package:webview_windows/webview_windows.dart';

class Layout1 extends StatefulWidget {
  final TextEditingController htmlController;
  final TextEditingController cssController;
  final TextEditingController jsController;
  final void Function(String) codecompile;
  final WebviewController webviewController;
  const Layout1(
      {super.key,
      required this.htmlController,
      required this.codecompile,
      required this.cssController,
      required this.jsController,
      required this.webviewController});

  @override
  State<Layout1> createState() => _Layout1State();
}

class _Layout1State extends State<Layout1> {
  double _sideBoxWidth = 500;
  final double _minSideBoxWidth = 70.0;

  double _htmlHeightFraction = 1 / 3;
  double _cssHeightFraction = 1 / 3;
  double _jsHeightFraction = 1 / 3;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double totalHeight = constraints.maxHeight;

      double htmlHeight = totalHeight * _htmlHeightFraction;
      double cssHeight = totalHeight * _cssHeightFraction;
      double jsHeight = totalHeight * _jsHeightFraction;

      return Row(children: [
        SizedBox(
          width: _sideBoxWidth,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Flexible(
                  flex: (_htmlHeightFraction * 1000).toInt(),
                  child: SizedBox(
                      height: htmlHeight,
                      child: textfield(
                          widget.htmlController, 'HTML', widget.codecompile)),
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
                      child: textfield(
                          widget.cssController, 'CSS', widget.codecompile)),
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
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              _sideBoxWidth += details.delta.dx;
              if (_sideBoxWidth < _minSideBoxWidth) {
                _sideBoxWidth = _minSideBoxWidth;
              }
              if (_sideBoxWidth > constraints.maxWidth - _minSideBoxWidth) {
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
