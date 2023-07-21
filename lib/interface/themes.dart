import 'package:flutter/material.dart';

class Themes {
  static MaterialColor colour = Colors.red;

  static ThemeData lightTheme = ThemeData(
    primaryColor: colour.shade600,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    appBarTheme: AppBarTheme(backgroundColor: colour.shade600),
    buttonTheme: ButtonThemeData(buttonColor: colour.shade600),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colour.shade600,
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colour.shade600,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: colour.shade900,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    appBarTheme: AppBarTheme(backgroundColor: colour.shade900),
    buttonTheme: ButtonThemeData(buttonColor: colour.shade900),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colour.shade900,
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colour.shade900,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    ),
  );
}
