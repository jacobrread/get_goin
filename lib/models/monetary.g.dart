// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonetaryAdapter extends TypeAdapter<Monetary> {
  @override
  final int typeId = 3;

  @override
  Monetary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Monetary(
      total: fields[0] as double,
      spent: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Monetary obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.total)
      ..writeByte(1)
      ..write(obj.spent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonetaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
