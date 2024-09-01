import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_css_js/screens/editor_screen.dart';
import 'package:html_css_js/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // _loadTheme();
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
        _themeMode = ThemeMode.dark;
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
    } else if (kIsWeb) {
      setState(() {
        _themeMode = ThemeMode.dark;
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
        // themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        home: const HomePage());
  }
}
