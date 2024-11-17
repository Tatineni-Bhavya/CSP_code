import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './bottom_navigation.dart';
void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}
class _MyAppState extends State<MyApp> {
  @override
   ThemeMode _themeMode = ThemeMode.light;
   
   void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;                   
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
       title: 'wellness Break',
       themeMode: _themeMode,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const bottombar(),
    );
  }
}