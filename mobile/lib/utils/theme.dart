import 'package:flutter/material.dart';

ThemeData whiteTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
    ),
    primaryColor: Colors.white,
    accentColor: Colors.black,
    focusColor: Colors.black,
    hoverColor: Colors.black,
    errorColor: Colors.red,
    textSelectionColor: Colors.grey.shade400,
    primaryTextTheme: TextTheme(
        subtitle1: TextStyle(
          color: Colors.grey.shade100,
        ),
        subtitle2: TextStyle(
          color: Colors.grey.shade400,
        )),
  );
}
