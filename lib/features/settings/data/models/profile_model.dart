import 'package:hive/hive.dart';
import 'grading_scale_model.dart';

class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final List<GradingScaleModel> gradingScale;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.gradingScale,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final scaleList = json['grading_scale'] as List<dynamic>? ?? [];
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
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
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.gradingScale);
  }
}
