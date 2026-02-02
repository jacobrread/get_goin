// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarEntryAdapter extends TypeAdapter<CalendarEntry> {
  @override
  final int typeId = 1;

  @override
  CalendarEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarEntry(
      id: fields[0] as String,
      goalId: fields[1] as String,
      date: fields[2] as DateTime,
      progress: fields[3] as int,
      success: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
