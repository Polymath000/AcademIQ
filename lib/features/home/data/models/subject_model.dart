import 'package:hive/hive.dart';

class SubjectModel {
  final String id;
  final String semesterId;
  final String userId;
  final String name;
  final int credits;
  final String gradeLetter;
  final DateTime createdAt;

  SubjectModel({
    required this.id,
    required this.semesterId,
    required this.userId,
    required this.name,
    required this.credits,
    required this.gradeLetter,
    required this.createdAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      semesterId: json['semester_id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      credits: json['credits'] as int,
      gradeLetter: json['grade_letter'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'semester_id': semesterId,
      'user_id': userId,
      'name': name,
      'credits': credits,
      'grade_letter': gradeLetter,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SubjectModel copyWith({
    String? id,
    String? semesterId,
    String? userId,
    String? name,
    int? credits,
    String? gradeLetter,
    DateTime? createdAt,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      semesterId: semesterId ?? this.semesterId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      gradeLetter: gradeLetter ?? this.gradeLetter,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SubjectHiveAdapter extends TypeAdapter<SubjectModel> {
  @override
  final int typeId = 2;

  @override
  SubjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectModel(
      id: fields[0] as String,
      semesterId: fields[1] as String,
      userId: fields[2] as String,
      name: fields[3] as String,
      credits: fields[4] as int,
      gradeLetter: fields[5] as String,
      createdAt: DateTime.parse(fields[6] as String),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.semesterId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.credits)
      ..writeByte(5)
      ..write(obj.gradeLetter)
      ..writeByte(6)
      ..write(obj.createdAt.toIso8601String());
  }
}
