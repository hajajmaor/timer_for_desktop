import 'package:flutter/material.dart';
import 'package:timer_for_desktop/screens/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      //TODO: remove this themeMode
      themeMode: ThemeMode.dark,
      home: MainPage(),
    );
  }
}
