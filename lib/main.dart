import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/archive.dart';
import 'screens/history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      routes: <String, WidgetBuilder>{
        //All available pages
        '/home': (BuildContext context) => Home(),
        '/archive': (BuildContext context) => Archive(),
        '/history': (BuildContext context) => History(),
      },
      home: Home(), //first page displayed
    );
  }
}
