// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerDataAdapter extends TypeAdapter<TimerData> {
  @override
  final int typeId = 0;

  @override
  TimerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerData(
      name: fields[0] as String?,
      seconds: fields[1] as int?,
      minutes: fields[2] as int?,
      hours: fields[3] as int?,
      lastActivated: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TimerData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.seconds)
      ..writeByte(2)
      ..write(obj.minutes)
      ..writeByte(3)
      ..write(obj.hours)
      ..writeByte(4)
      ..write(obj.lastActivated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
