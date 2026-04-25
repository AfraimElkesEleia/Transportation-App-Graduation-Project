// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentSearchModelAdapter extends TypeAdapter<RecentSearchModel> {
  @override
  final int typeId = 1;

  @override
  RecentSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearchModel(
      id: fields[0] as String,
      fromDisplayName: fields[1] as String,
      toDisplayName: fields[2] as String,
      fromGovernorate: fields[3] as String?,
      fromStationId: fields[4] as int?,
      toGovernorate: fields[5] as String?,
      toStationId: fields[6] as int?,
      travelDate: fields[7] as String,
      isRoundTrip: fields[8] as bool,
      returnDate: fields[9] as String?,
      passengers: fields[10] as int,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSearchModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromDisplayName)
      ..writeByte(2)
      ..write(obj.toDisplayName)
      ..writeByte(3)
      ..write(obj.fromGovernorate)
      ..writeByte(4)
      ..write(obj.fromStationId)
      ..writeByte(5)
      ..write(obj.toGovernorate)
      ..writeByte(6)
      ..write(obj.toStationId)
      ..writeByte(7)
      ..write(obj.travelDate)
      ..writeByte(8)
      ..write(obj.isRoundTrip)
      ..writeByte(9)
      ..write(obj.returnDate)
      ..writeByte(10)
      ..write(obj.passengers)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
