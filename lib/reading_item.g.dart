// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadingItemAdapter extends TypeAdapter<ReadingItem> {
  @override
  final int typeId = 0;

  @override
  ReadingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadingItem(
      reading: fields[0] as int,
      time: fields[1] as String,
      date: fields[2] as String,
      feedingState: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReadingItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.reading)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.feedingState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
