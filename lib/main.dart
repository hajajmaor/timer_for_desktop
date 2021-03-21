import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_for_desktop/screens/main_page.dart';

import 'constants.dart';
import 'models/timer_data.dart';

Future<void> main() async {
  // init hive as local storage
  await Hive.initFlutter();
  Hive.registerAdapter(TimerDataAdapter());

  //open hive boxes
  await Hive.openBox<TimerData>(dTimerDataBoxName);

  // ProviderScope for Riverpod state management
  runApp(ProviderScope(
    child: PlatformProvider(
      // initialPlatform: TargetPlatform.windows,
      builder: (BuildContext context) => MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      material: (_, __) => MaterialAppData(
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: dAppBarGlobal,
        ),
        theme: ThemeData.light().copyWith(
          appBarTheme: dAppBarGlobal,
        ),
      ),
      home: MainPage(),
      // home: MyHomePage(title: "Hello"),
    );
  }
}
