import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:timer_for_desktop/components/timer_row.dart';

import 'package:timer_for_desktop/constants.dart';
import 'package:timer_for_desktop/models/timer_data.dart';

class TimerView extends StatefulWidget {
  final TimerData timerData;

  const TimerView({Key? key, required this.timerData}) : super(key: key);

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;
  late final TextEditingController _nameController;
  late final TextEditingController _secondsController;
  Duration? _timeToRun;
  Timer? _timer;

  // ignore: prefer_const_constructors
  Duration _timePassed = Duration();

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController(text: '0');
    _minutesController = TextEditingController(text: '0');
    _secondsController = TextEditingController(text: '0');
    _nameController =
        TextEditingController(text: widget.timerData.name ?? 'name');
  }

  String getRemainingTime() {
    if (_timeToRun == null) {
      return '00:00:00';
    }
    final remainingTime = _timeToRun! - _timePassed;
    final int hours = remainingTime.inHours;
    final int minutes = remainingTime.inMinutes % 60;
    final int seconds = remainingTime.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}: ${minutes.toString().padLeft(2, '0')}: ${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _hoursController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final bool isCupertino =
        PlatformProvider.of(context)!.platform == TargetPlatform.macOS ||
            PlatformProvider.of(context)!.platform == TargetPlatform.iOS;
    return Container(
      padding: EdgeInsets.all(
        isCupertino ? 20 : 5,
      ),
      margin: const EdgeInsets.all(8),
      color: Colors.amberAccent,
      constraints: BoxConstraints(
        // minWidth: 400,
        maxWidth: 330,
        maxHeight: width > 300 ? 415 : 600,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: PlatformTextField(
                        textAlign: TextAlign.center,
                        // style: TextStyle(),
                        controller: _nameController,
                        onChanged: (value) => widget.timerData.name = value,
                      ),
                    ),
                  ),
                  TimerRow(
                    onChanged: (String value) {
                      widget.timerData.hours = int.tryParse(value) ?? 0;
                    },
                    controller: _hoursController,
                    text: 'Hours',
                    context: context,
                    width: width,
                  ),
                  TimerRow(
                    onChanged: (String value) {
                      widget.timerData.minutes = int.tryParse(value) ?? 0;
                    },
                    controller: _minutesController,
                    text: 'Minutes',
                    context: context,
                    width: width,
                  ),
                  TimerRow(
                    onChanged: (String value) {
                      widget.timerData.seconds = int.tryParse(value) ?? 0;
                    },
                    controller: _secondsController,
                    text: 'Seconds',
                    context: context,
                    width: width,
                  ),
                  SizedBox(
                    height: isCupertino ? 0 : 20,
                  ),
                  SizedBox(
                    width: width > 400 ? 300 : 215,
                    height: 50,
                    child: Flex(
                      direction: width > 400 ? Axis.horizontal : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: PlatformButton(
                            materialFlat: (_, __) => MaterialFlatButtonData(),
                            onPressed: () => setState(
                              () {
                                (_timer?.isActive ?? false)
                                    ? _timer!.cancel()
                                    : _secondsController.text = '0';
                                _minutesController.text = '0';
                                _hoursController.text = '0';
                                widget.timerData.setZero();
                                _timeToRun = const Duration();
                                _timePassed = const Duration();
                              },
                            ),
                            child: PlatformText(
                              (_timer?.isActive ?? false) ? 'Stop' : 'Clear',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: width > 400 ? 0 : 20,
                        ),
                        Expanded(
                          child: PlatformButton(
                            materialFlat: (context, platform) =>
                                MaterialFlatButtonData(),
                            onPressed: () {
                              if (_timer != null) {
                                _timer!.cancel();
                              }
                              _timeToRun = Duration(
                                hours: widget.timerData.hours ?? 0,
                                minutes: widget.timerData.minutes ?? 0,
                                seconds: widget.timerData.seconds ?? 0,
                              );
                              if (_timeToRun! > const Duration()) {
                                _timer = Timer.periodic(
                                  dOneSec,
                                  (timed) {
                                    setState(() {
                                      _timePassed =
                                          Duration(seconds: timed.tick);
                                      if (_timePassed >= _timeToRun!) {
                                        _timer!.cancel();
                                        //TODO: make a sound
                                        showPlatformDialog(
                                          context: context,
                                          builder: (context) =>
                                              PlatformAlertDialog(
                                            actions: [
                                              PlatformDialogAction(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: PlatformText('OK'),
                                              ),
                                            ],
                                            content: PlatformText(
                                              'Timer: ${widget.timerData.name}: Time Passed',
                                              style: const TextStyle(
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                );
                              }
                            },
                            child: PlatformText(
                              'Start countdown',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Time:',
                    style: dTimerHeader,
                  ),
                  Text(
                    getRemainingTime(),
                    style: dTimerTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Tooltip(
              message: 'Delete this timer',
              child: PlatformIconButton(
                onPressed: () async {
                  final box = Hive.box<TimerData>(dTimerDataBoxName);
                  final data = box.values;
                  for (var i = 0; i < data.length; i++) {
                    if (data.elementAt(i) == widget.timerData) {
                      await box.deleteAt(i);
                      return;
                    }
                  }
                },
                icon: Icon(
                  PlatformIcons(context).delete,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
