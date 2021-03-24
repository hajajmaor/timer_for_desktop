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
  Future<void> createNewTimerData({required BuildContext context}) async {
    final _new = TimerData();
    final _box = Hive.box<TimerData>(dTimerDataBoxName);

    if (!_box.values.contains(_new)) {
      await _box.add(_new);
    } else {
      showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
          content: PlatformText(
            'You already have new timer, use it',
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          actions: [
            PlatformDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: PlatformText('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _box = Hive.box<TimerData>(dTimerDataBoxName);
    final bool isCupertino =
        PlatformProvider.of(context)!.platform == TargetPlatform.macOS ||
            PlatformProvider.of(context)!.platform == TargetPlatform.iOS;

    return PlatformScaffold(
      material: (context, __) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewTimerData(
              context: context,
            );
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
            onPressed: () {
              createNewTimerData(
                context: context,
              );
            },
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
                      viewportFraction: 0.70,
                      enableInfiniteScroll: false,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, index, __) =>
                        TimerView(timerData: items.elementAt(index)),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                    top: isCupertino ? 45 : 0,
                  ),
                  child: Builder(
                    builder: (_) {
                      final List<Widget> widgets = [];
                      for (final item in items) {
                        widgets.add(TimerView(timerData: item));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: widgets,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
