import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  late Timer? _timer;
  // ignore: prefer_const_constructors
  Duration _timePassed = Duration();

  @override
  void initState() {
    super.initState();
    _hoursController = _minutesController =
        _secondsController = TextEditingController(text: '0');
  }

  void activateTimer() {
    if (_timeToRun == null) {
      return;
    } else {
      _timer = Timer.periodic(
        dOneSec,
        (timed) {
          setState(() {
            _timePassed += dOneSec;
            if (_timePassed >= _timeToRun!) {
              _timer!.cancel();
              //TODO: make a sound

            }
          });
        },
      );
    }
  }

  String getRemainingTime() {
    if (_timeToRun == null) {
      return '00:00:00';
    }
    final remainingTime = _timeToRun! - _timePassed;
    final int hours = remainingTime.inHours / 24 as int;
    final int minutes = remainingTime.inMinutes - (hours * 24) / 60 as int;
    final int seconds =
        remainingTime.inSeconds - (hours * 24) - (minutes * 60) / 60 as int;
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
  }) =>
      Center(
        child: SizedBox(
          height: 80,
          width: 180,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PlatformText(text),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: PlatformTextField(
                  controller: controller,
                  // style: TextStyle(),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  // decoration: InputDecoration(),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(
        PlatformProvider.of(context)!.platform == TargetPlatform.macOS ||
                PlatformProvider.of(context)!.platform == TargetPlatform.iOS
            ? 40
            : 5,
      ),
      constraints: const BoxConstraints(
        minWidth: 400,
        maxHeight: 600,
      ),
      // width: 400,
      // height: 400,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRow(controller: _hoursController, text: 'Hours'),
              _buildRow(controller: _minutesController, text: 'Minutes'),
              _buildRow(controller: _secondsController, text: 'Seconds'),
              SizedBox(
                height: PlatformProvider.of(context)!.platform ==
                            TargetPlatform.macOS ||
                        PlatformProvider.of(context)!.platform ==
                            TargetPlatform.iOS
                    ? 0
                    : 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: PlatformButton(
                      materialFlat: (context, platform) =>
                          MaterialFlatButtonData(),
                      onPressed: () {
                        _secondsController.text = _minutesController.text =
                            _hoursController.text = '0';
                      },
                      child: PlatformText(
                        'Clear',
                      ),
                    ),
                  ),
                  Expanded(
                    child: PlatformButton(
                      materialFlat: (context, platform) =>
                          MaterialFlatButtonData(),
                      onPressed: () {
                        //TODO: Start the timer with the values from the controllers.
                      },
                      child: PlatformText('Start countdown'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
