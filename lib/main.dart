import 'package:flutter/material.dart';
import 'screens/Home.dart';
import 'screens/Archive.dart';
import 'screens/History.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      routes: <String, WidgetBuilder>{
        //All available pages
        '/Home': (BuildContext contrext) => Home(),
        '/Archive': (BuildContext contrext) => Archive(),
        '/History': (BuildContext contrext) => History(),
      },
      home: Home(), //first page displayed
    );
  }
}
