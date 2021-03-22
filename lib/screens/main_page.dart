import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:timer_for_desktop/components/switch_platform_icon.dart';
import 'package:timer_for_desktop/constants.dart';
import 'package:timer_for_desktop/models/timer_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_for_desktop/views/timer_view.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _box = Hive.box<TimerData>(dTimerDataBoxName);

    Future<void> createNewTimerData({BuildContext? context}) async {
      final _new = TimerData();
      // if (!_box.values.contains(_new)) {
      await _box.add(_new);
      // } else {
      //   showToastWidget(const Text('you have empty timer already, use it'),
      //       context: context);
      // }
    }

    return PlatformScaffold(
      material: (context, __) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewTimerData();
          },
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
        builder: (context, Box<TimerData> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: SizedBox(
                  child: Center(
                child: Text(
                  'Press the + button to open new timer',
                ),
              )),
            );
          }
          final items = box.values;
          return LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              if (constraints.maxWidth < 700 || constraints.maxHeight < 400) {
                return Center(
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: constraints.maxWidth > 400 ? 420 : 540,
                      // pageSnapping: false,
                      viewportFraction: 0.70,
                      enableInfiniteScroll: false,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, index, __) =>
                        TimerView(timerData: items.elementAt(index)),
                  ),
                );
              } else {
                return Builder(
                  builder: (_) {
                    final List<Widget> widgets = [];
                    for (final item in items) {
                      widgets.add(TimerView(timerData: item));
                    }

                    //  box.values.forEach((element) =>TimerView(timerData: element));
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Wrap(
                          // direction: Axis.vertical,

                          // verticalDirection: VerticalDirection.up,
                          // alignment: WrapAlignment.spaceBetween,
                          children: widgets,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
