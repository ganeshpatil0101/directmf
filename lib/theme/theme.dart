import 'package:flutter/material.dart';

import 'icons.dart';

final appTheme = ThemeData(
    backgroundColor: Colors.purple,
    iconTheme: IconThemeData(
      size: ICON_SIZE,
    ),
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      body1: TextStyle(fontSize: 16.0),
      body2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      display1: TextStyle(
          fontSize: 21.0, fontWeight: FontWeight.w500, color: Colors.black87),
    ));
