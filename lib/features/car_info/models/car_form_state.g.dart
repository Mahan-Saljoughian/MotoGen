// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_form_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarFormStateAdapter extends TypeAdapter<CarFormState> {
  @override
  final int typeId = 0;

  @override
  CarFormState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarFormState(
      brand: fields[0] as PickerItem?,
      model: fields[2] as PickerItem?,
      type: fields[1] as PickerItem?,
      yearMade: fields[3] as int?,
      color: fields[4] as PickerItem?,
      kilometerDriven: fields[5] as int?,
      fuelType: fields[6] as PickerItem?,
      bodyInsuranceExpiry: fields[7] as DateTime?,
      thirdPartyInsuranceExpiry: fields[11] as DateTime?,
      nextTechnicalCheck: fields[8] as DateTime?,
      rawKilometersInput: fields[9] as String?,
      nickName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CarFormState obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.yearMade)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.kilometerDriven)
      ..writeByte(6)
      ..write(obj.fuelType)
      ..writeByte(7)
      ..write(obj.bodyInsuranceExpiry)
      ..writeByte(8)
      ..write(obj.nextTechnicalCheck)
      ..writeByte(9)
      ..write(obj.rawKilometersInput)
      ..writeByte(10)
      ..write(obj.nickName)
      ..writeByte(11)
      ..write(obj.thirdPartyInsuranceExpiry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarFormStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
