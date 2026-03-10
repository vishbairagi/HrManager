import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  // Start with light theme
  bool isDarkMode = false;

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners(); // Updates all listeners/screens
  }

  // Light Theme
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
  );
}