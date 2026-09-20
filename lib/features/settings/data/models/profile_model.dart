import 'package:hive/hive.dart';
import 'grading_scale_model.dart';

class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final List<GradingScaleModel> gradingScale;
  final double cgpa;
  final int totalCredits;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.gradingScale,
    this.cgpa = 0.0,
    this.totalCredits = 0,
  });

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? email,
    List<GradingScaleModel>? gradingScale,
    double? cgpa,
    int? totalCredits,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gradingScale: gradingScale ?? this.gradingScale,
      cgpa: cgpa ?? this.cgpa,
      totalCredits: totalCredits ?? this.totalCredits,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final scaleList = json['grading_scale'] as List<dynamic>? ?? [];
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      cgpa: (json['cgpa'] as num?)?.toDouble() ?? 0.0,
      totalCredits: json['total_credits'] as int? ?? 0,
      gradingScale: scaleList
          .map((e) => GradingScaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'cgpa': cgpa,
      'total_credits': totalCredits,
      'grading_scale': gradingScale.map((e) => e.toJson()).toList(),
    };
  }
}

class ProfileHiveAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 0;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      gradingScale: (fields[3] as List).cast<GradingScaleModel>(),
      cgpa: fields[4] as double? ?? 0.0,
      totalCredits: fields[5] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.gradingScale)
      ..writeByte(4)
      ..write(obj.cgpa)
      ..writeByte(5)
      ..write(obj.totalCredits);
  }
}
