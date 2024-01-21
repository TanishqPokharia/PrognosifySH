// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prognosify_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrognosifyNotificationAdapter
    extends TypeAdapter<PrognosifyNotification> {
  @override
  final int typeId = 1;

  @override
  PrognosifyNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrognosifyNotification(
        time: fields[0].toString(),
        body: fields[1] as String,
        id: fields[2] as int);
  }

  @override
  void write(BinaryWriter writer, PrognosifyNotification obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrognosifyNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
