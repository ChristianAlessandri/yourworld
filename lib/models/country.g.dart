// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryAdapter extends TypeAdapter<Country> {
  @override
  final int typeId = 1;

  @override
  Country read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Country(
      isoA2: fields[0] as String,
      name: fields[1] as String,
      continent: fields[2] as String,
      subregion: fields[3] as String,
      status: fields[4] as CountryStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Country obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isoA2)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.continent)
      ..writeByte(3)
      ..write(obj.subregion)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
