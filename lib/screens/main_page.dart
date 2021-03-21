import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:timer_for_desktop/components/switch_platform_icon.dart';
import 'package:timer_for_desktop/constants.dart';
import 'package:timer_for_desktop/models/timer_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_for_desktop/views/timer_view.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _box = Hive.box<TimerData>(dTimerDataBoxName);
    return PlatformScaffold(
      material: (_, __) => MaterialScaffoldData(
          floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final _new = TimerData();
          if (!_box.values.contains(_new)) {
            await _box.add(_new);
          }
        },
        tooltip: "Add a new timer",
        child: Icon(Icons.add),
      )),
      appBar: PlatformAppBar(
        leading: SwitchPlatformIcon(),
        title: PlatformText("Timer"),
      ),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, Box<TimerData> box, _) => box.isEmpty
            ? Container()
            : PageIndicatorContainer(
                length: box.length,
                align: IndicatorAlign.bottom,
                child: PageView.builder(
                  itemCount: box.length,
                  itemBuilder: (_, index) =>
                      TimerView(timerData: box.getAt(index)!),
                ),
                indicatorSpace: 10.0,
              ),
      ),
    );
  }
}
