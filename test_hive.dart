import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:gpa_calculator/features/home/data/models/semester_model.dart';
import 'dart:io';

void main() async {
  Hive.init(Directory.current.path);
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(SemesterHiveAdapter());
  
  final box = await Hive.openBox<SemesterModel>('testBox');
  final sem = SemesterModel(
    id: '123',
    userId: 'user',
    name: 'Test',
    orderIndex: 0,
    createdAt: DateTime.now(),
  );
  try {
    await box.put(sem.id, sem);
    print('SUCCESS');
  } catch (e) {
    print('ERROR: $e');
  }
}
