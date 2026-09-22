import 'package:hive/hive.dart';

class SyncActionTypes {
  static const String addSemester = 'ADD_SEMESTER';
  static const String updateSemester = 'UPDATE_SEMESTER';
  static const String deleteSemester = 'DELETE_SEMESTER';
  static const String addSubject = 'ADD_SUBJECT';
  static const String updateSubject = 'UPDATE_SUBJECT';
  static const String deleteSubject = 'DELETE_SUBJECT';
  static const String syncCgpa = 'SYNC_CGPA';
}

class SyncActionModel {
  final String id;
  final String actionType;
  final String payload;
  final DateTime createdAt;

  SyncActionModel({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.createdAt,
  });
}

class SyncActionHiveAdapter extends TypeAdapter<SyncActionModel> {
  @override
  final int typeId = 3;

  @override
  SyncActionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncActionModel(
      id: fields[0] as String,
      actionType: fields[1] as String,
      payload: fields[2] as String,
      createdAt: DateTime.parse(fields[3] as String),
    );
  }

  @override
  void write(BinaryWriter writer, SyncActionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actionType)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.createdAt.toIso8601String());
  }
}
