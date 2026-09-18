import 'package:hive/hive.dart';

class GradingScaleModel {
  final String letter;
  final double gpa;
  final int minScore;
  final bool enable;

  GradingScaleModel({
    required this.letter,
    required this.gpa,
    required this.minScore,
    required this.enable,
  });

  factory GradingScaleModel.fromJson(Map<String, dynamic> json) {
    return GradingScaleModel(
      letter: json['letter'] as String,
      gpa: (json['gpa'] as num).toDouble(),
      minScore: json['minScore'] as int,
      enable: json['enable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'letter': letter,
      'gpa': gpa,
      'minScore': minScore,
      'enable': enable,
    };
  }
}

class GradingScaleHiveAdapter extends TypeAdapter<GradingScaleModel> {
  @override
  final int typeId = 1;

  @override
  GradingScaleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradingScaleModel(
      letter: fields[0] as String,
      gpa: fields[1] as double,
      minScore: fields[2] as int,
      enable: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GradingScaleModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.letter)
      ..writeByte(1)
      ..write(obj.gpa)
      ..writeByte(2)
      ..write(obj.minScore)
      ..writeByte(3)
      ..write(obj.enable);
  }
}
