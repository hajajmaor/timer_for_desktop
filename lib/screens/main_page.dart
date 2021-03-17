import 'dart:async';
import 'package:flutter/material.dart';

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
        child: Container(
          height: 80,
          width: 150,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(text),
              ),
              SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: TextField(
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          minWidth: 400,
          maxHeight: 450,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          _secondsController.text = _minutesController.text =
                              _hoursController.text = '0';
                        },
                        child: Text('Clear'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        child: Text('Start countdown'),
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
