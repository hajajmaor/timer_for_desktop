import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timer_for_desktop/screens/main_page.dart';

void main() {
  runApp(ProviderScope(
    child: PlatformProvider(
      // initialPlatform: TargetPlatform.windows,
      builder: (BuildContext context) => MyApp(),
    ),
  ));
}

const appBarGlobal = AppBarTheme(
  centerTitle: true,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      material: (_, __) => MaterialAppData(
        darkTheme: ThemeData.dark().copyWith(appBarTheme: appBarGlobal),
        theme: ThemeData.light().copyWith(appBarTheme: appBarGlobal),
        //TODO: remove this themeMode
      ),
      home: MainPage(),
    );
  }
}
