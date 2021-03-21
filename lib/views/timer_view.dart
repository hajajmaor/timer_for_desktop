import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
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
  late final TextEditingController _hoursController,
      _minutesController,
      _secondsController;
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
  }

  void activateTimer() {}

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

  Widget _buildRow({
    required TextEditingController controller,
    required String text,
    required BuildContext context,
    required double width,
    required void Function(String) onChanged,
  }) =>
      Center(
        child: Container(
          // color: Colors.green,
          padding: const EdgeInsets.all(5),
          height: width > 300 ? 80 : 105,
          width: 200,
          child: Flex(
            direction: width > 300 ? Axis.horizontal : Axis.vertical,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlatformText('$text:'),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: 80,
                child: PlatformTextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  textAlign: TextAlign.center,
                  onChanged: onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(dRegExpNumbers),
                  ],
                  material: (context, platform) => MaterialTextFieldData(
                    decoration:
                        const InputDecoration(counterText: 'Numbers only'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(
            PlatformProvider.of(context)!.platform == TargetPlatform.macOS ||
                    PlatformProvider.of(context)!.platform == TargetPlatform.iOS
                ? 40
                : 5,
          ),
          // color: Colors.amberAccent,

          constraints: const BoxConstraints(
            minWidth: 400,
            maxHeight: 500,
          ),
          // color: Colors.red,
          // width: 400,
          // height: 400,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRow(
                    onChanged: (String value) {
                      widget.timerData.hours = int.tryParse(value) ?? 0;
                    },
                    controller: _hoursController,
                    text: 'Hours',
                    context: context,
                    width: width,
                  ),
                  _buildRow(
                    onChanged: (String value) {
                      widget.timerData.minutes = int.tryParse(value) ?? 0;
                    },
                    controller: _minutesController,
                    text: 'Minutes',
                    context: context,
                    width: width,
                  ),
                  _buildRow(
                    onChanged: (String value) {
                      widget.timerData.seconds = int.tryParse(value) ?? 0;
                    },
                    controller: _secondsController,
                    text: 'Seconds',
                    context: context,
                    width: width,
                  ),
                  SizedBox(
                    height: PlatformProvider.of(context)!.platform ==
                                TargetPlatform.macOS ||
                            PlatformProvider.of(context)!.platform ==
                                TargetPlatform.iOS
                        ? 0
                        : 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: width > 300 ? 300 : 215,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: PlatformButton(
                              materialFlat: (context, platform) =>
                                  MaterialFlatButtonData(),
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
                                            content: PlatformText(
                                              'Time Passed',
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
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: PlatformIconButton(
            onPressed: () async {
              // Hive.box<TimerData>(dTimerDataBoxName).values.firstWhere(
              // (element) => element == widget.timerData,
              // );
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
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
