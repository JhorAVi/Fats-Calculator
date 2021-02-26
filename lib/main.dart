import 'package:bmicalculator/menu.dart';
import 'package:flutter/material.dart';
import 'input_page.dart';
import 'package:flutter/services.dart'; // has protrait fix mode
import 'menu.dart';

void main() {
  runApp(BMIApp());
}

class BMIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fixed to Portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        //primaryColor: Color(0xFF0A0E21),
        primaryColor: Colors.black,
        //scaffoldBackgroundColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Menu(),
    );
  }
}
