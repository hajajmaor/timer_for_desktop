import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final TextEditingController _hoursController,
      _minutesController,
      _secondsController;
  Timer? _timer;
  final _oneSec = Duration(seconds: 1);
  Duration _timePassed = Duration(seconds: 0);
  Duration? _timeToRun;
  @override
  void initState() {
    super.initState();
    _hoursController = _minutesController =
        _secondsController = TextEditingController(text: '0');
  }

  // @override
  // void dispose() {
  //   _minutesController.dispose();
  //   _hoursController.dispose();
  //   _secondsController.dispose();
  //   super.dispose();
  // }

  Widget _buildRow({
    required TextEditingController controller,
    required String text,
  }) =>
      Center(
        child: Container(
          height: 80,
          width: 180,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: PlatformText(text),
              ),
              SizedBox(width: 30),
              Expanded(
                flex: 1,
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

  //TODO: check the function

  // String timerText =>
  //     '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  String getRemainingTime() {
    if (_timeToRun == null) {
      return '00:00:00';
    }
    final remainingTime = _timeToRun! - _timePassed;
    final int hours = (remainingTime.inHours / 24) as int;
    final int minutes = (remainingTime.inMinutes - (hours * 24) / 60) as int;
    final int seconds =
        (remainingTime.inSeconds - (hours * 24) - (minutes * 60) / 60) as int;
    return '${hours.toString().padLeft(2, '0')}: ${(minutes.toString().padLeft(2, '0'))}: ${(seconds.toString().padLeft(2, '0'))}';
  }

  activateTimer() {
    if (_timeToRun == null)
      return;
    else {
      _timer = Timer.periodic(
        _oneSec,
        (timed) {
          setState(() {
            _timePassed += Duration(seconds: 1);
            if (_timePassed >= _timeToRun!) {
              _timer!.cancel();
              //TODO: make a sound

            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        leading: PlatformIconButton(
          icon: Icon(Icons.track_changes),
          onPressed: () {
            final currentPlatform = PlatformProvider.of(context)!.platform;
            if (currentPlatform == TargetPlatform.macOS ||
                currentPlatform == TargetPlatform.iOS)
              PlatformProvider.of(context)!.changeToMaterialPlatform();
            else
              PlatformProvider.of(context)!.changeToCupertinoPlatform();
          },
        ),
        title: PlatformText("Timer"),
      ),
      body: Container(
        padding: EdgeInsets.all(
          PlatformProvider.of(context)!.platform == TargetPlatform.macOS ||
                  PlatformProvider.of(context)!.platform == TargetPlatform.iOS
              ? 40
              : 5,
        ),
        constraints: BoxConstraints(
          minWidth: 400,
          maxHeight: 600,
        ),
        // width: 400,
        // height: 400,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      flex: 1,
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
                      flex: 1,
                      child: PlatformButton(
                        materialFlat: (context, platform) =>
                            MaterialFlatButtonData(),
                        child: PlatformText('Start countdown'),
                        onPressed: () {
                          //TODO: Start the timer with the values from the controllers.
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  'Time:',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  getRemainingTime(),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
