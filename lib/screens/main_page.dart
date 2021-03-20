import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:timer_for_desktop/components/switch_platform_icon.dart';
import 'package:timer_for_desktop/constants.dart';
import 'package:timer_for_desktop/models/timer_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * TODO: add this:
     *  https://pub.dev/packages/page_view_indicators/example
     * */
    return PlatformScaffold(
        appBar: PlatformAppBar(
          leading: SwitchPlatformIcon(),
          title: PlatformText("Timer"),
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<TimerData>(dTimerDataBoxName).listenable(),
          builder: (context, Box<TimerData> box, _) {
            if (box.isEmpty)
              return Container();
            else {
              //TODO: build a pageview with every instance of TimerData.
              return PageView();
            }
          },
        ));
  }
}
