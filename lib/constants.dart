import 'package:flutter/material.dart';
import 'package:timer_for_desktop/models/timer_data.dart';

/// Hive box name for the [TimerData] local data
const dTimerDataBoxName = "timer_data_box";

///material [AppBar] global settings
const dAppBarGlobal = AppBarTheme(
  centerTitle: true,
);

const dOneSec = Duration(seconds: 1);
const dTimerTextStyle = TextStyle();
const dTimerHeader = TextStyle();
// ignore: unnecessary_raw_strings
final dRegExpNumbers = RegExp(r'[0-9]');
