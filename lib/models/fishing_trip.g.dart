// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fishing_trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishingTripAdapter extends TypeAdapter<FishingTrip> {
  @override
  final int typeId = 0;

  @override
  FishingTrip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FishingTrip(
      id: fields[0] as String,
      pirogue: fields[1] as String,
      species: fields[2] as String,
      quantityKg: fields[3] as double,
      pricePerKg: fields[4] as int,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FishingTrip obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pirogue)
      ..writeByte(2)
      ..write(obj.species)
      ..writeByte(3)
      ..write(obj.quantityKg)
      ..writeByte(4)
      ..write(obj.pricePerKg)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishingTripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
