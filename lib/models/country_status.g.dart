// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryStatusAdapter extends TypeAdapter<CountryStatus> {
  @override
  final int typeId = 2;

  @override
  CountryStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CountryStatus.none;
      case 1:
        return CountryStatus.visited;
      case 2:
        return CountryStatus.want;
      case 3:
        return CountryStatus.lived;
      default:
        return CountryStatus.none;
    }
  }

  @override
  void write(BinaryWriter writer, CountryStatus obj) {
    switch (obj) {
      case CountryStatus.none:
        writer.writeByte(0);
        break;
      case CountryStatus.visited:
        writer.writeByte(1);
        break;
      case CountryStatus.want:
        writer.writeByte(2);
        break;
      case CountryStatus.lived:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
