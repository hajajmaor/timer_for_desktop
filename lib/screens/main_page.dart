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

    Future<void> createNewTimerData() async {
      final _new = TimerData();
      if (!_box.values.contains(_new)) {
        await _box.add(_new);
      }
    }

    return PlatformScaffold(
      material: (_, __) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTimerData,
          tooltip: "Add a new timer",
          child: const Icon(Icons.add),
        ),
      ),
      appBar: PlatformAppBar(
        leading: SwitchPlatformIcon(),
        title: PlatformText("Timer"),
        cupertino: (context, platform) => CupertinoNavigationBarData(
          trailing: CupertinoButton(
            onPressed: createNewTimerData,
            child: const Icon(CupertinoIcons.add),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, Box<TimerData> box, _) => box.isEmpty
            ? Container()
            : Center(
                child: SizedBox(
                  height: 470,
                  width: 450,
                  child: PageIndicatorContainer(
                    length: box.length,
                    indicatorSpace: 10.0,
                    child: PageView.builder(
                      itemCount: box.length,
                      itemBuilder: (_, index) =>
                          TimerView(timerData: box.getAt(index)!),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
