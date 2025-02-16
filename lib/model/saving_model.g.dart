// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingModelAdapter extends TypeAdapter<SavingModel> {
  @override
  final int typeId = 1;

  @override
  SavingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingModel(
      description: fields[3] as String?,
      id: fields[0] as String?,
      savingAmount: fields[1] as String?,
      transactionDate: fields[2] as String?,
      goalId: fields[4] as String?,
      isWithdraw: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SavingModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.savingAmount)
      ..writeByte(2)
      ..write(obj.transactionDate)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.goalId)
      ..writeByte(5)
      ..write(obj.isWithdraw);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
