// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      originCountry: fields[0] as String,
      destinationCountry: fields[1] as String,
      destinationCity: fields[2] as String,
      visaType: fields[3] as String,
      xp: fields[4] as int,
      streakDays: fields[5] as int,
      badges: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.originCountry)
      ..writeByte(1)
      ..write(obj.destinationCountry)
      ..writeByte(2)
      ..write(obj.destinationCity)
      ..writeByte(3)
      ..write(obj.visaType)
      ..writeByte(4)
      ..write(obj.xp)
      ..writeByte(5)
      ..write(obj.streakDays)
      ..writeByte(6)
      ..write(obj.badges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
