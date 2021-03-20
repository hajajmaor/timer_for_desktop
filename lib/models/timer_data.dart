import 'dart:convert';

import 'package:hive/hive.dart';

part 'timer_data.g.dart';

@HiveType(typeId: 0)
class TimerData extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  int? seconds;
  @HiveField(2)
  int? minutes;
  @HiveField(3)
  int? hours;
  @HiveField(4)
  DateTime? lastActivated;

  TimerData({
    this.name,
    this.seconds,
    this.minutes,
    this.hours,
    this.lastActivated,
  });

  factory TimerData.fromJson(String source) =>
      TimerData.fromMap(json.decode(source));

  factory TimerData.fromMap(Map<String, dynamic> map) {
    return TimerData(
      name: map['name'],
      seconds: map['seconds'],
      minutes: map['minutes'],
      hours: map['hours'],
      lastActivated: DateTime.fromMillisecondsSinceEpoch(map['lastActivated']),
    );
  }

  @override
  int get hashCode {
    return name.hashCode ^
        seconds.hashCode ^
        minutes.hashCode ^
        hours.hashCode ^
        lastActivated.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimerData &&
        other.name == name &&
        other.seconds == seconds &&
        other.minutes == minutes &&
        other.hours == hours &&
        other.lastActivated == lastActivated;
  }

  TimerData copyWith({
    String? name,
    int? seconds,
    int? minutes,
    int? hours,
    DateTime? lastActivated,
  }) {
    return TimerData(
      name: name ?? this.name,
      seconds: seconds ?? this.seconds,
      minutes: minutes ?? this.minutes,
      hours: hours ?? this.hours,
      lastActivated: lastActivated ?? this.lastActivated,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'seconds': seconds,
      'minutes': minutes,
      'hours': hours,
      'lastActivated': lastActivated,
    };
  }

  @override
  String toString() {
    return 'TimerData(name: $name, seconds: $seconds, minutes: $minutes, hours: $hours, lastActivated: $lastActivated)';
  }
}
