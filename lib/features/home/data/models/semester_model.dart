import 'package:hive/hive.dart';

class SemesterModel {
  final String id;
  final String userId;
  final String name;
  final int orderIndex;
  final DateTime createdAt;

  SemesterModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.orderIndex,
    required this.createdAt,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      orderIndex: json['order_index'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SemesterModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return SemesterModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SemesterHiveAdapter extends TypeAdapter<SemesterModel> {
  @override
  final int typeId = 1;

  @override
  SemesterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SemesterModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      orderIndex: fields[3] as int,
      createdAt: DateTime.parse(fields[4] as String),
    );
  }

  @override
  void write(BinaryWriter writer, SemesterModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.orderIndex)
      ..writeByte(4)
      ..write(obj.createdAt.toIso8601String());
  }
}
