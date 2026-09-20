import 'package:hive/hive.dart';

import '../models/semester_model.dart';
import '../models/subject_model.dart';
import '../models/sync_action_model.dart';

abstract class HomeLocalDataSource {
  Future<List<SemesterModel>> getSemesters();
  Future<void> saveSemesters(List<SemesterModel> semesters);
  Future<void> addSemester(SemesterModel semester);
  Future<void> deleteSemester(String semesterId);

  Future<List<SubjectModel>> getSubjects();
  Future<void> saveSubjects(List<SubjectModel> subjects);
  Future<void> addSubject(SubjectModel subject);
  Future<void> updateSubject(SubjectModel subject);
  Future<void> deleteSubject(String subjectId);
  Future<void> deleteSubjectsBySemester(String semesterId);

  Future<List<SyncActionModel>> getSyncQueue();
  Future<void> addToSyncQueue(SyncActionModel action);
  Future<void> removeFromSyncQueue(String actionId);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Box<SemesterModel> _semestersBox;
  final Box<SubjectModel> _subjectsBox;
  final Box<SyncActionModel> _syncQueueBox;

  HomeLocalDataSourceImpl(
    this._semestersBox,
    this._subjectsBox,
    this._syncQueueBox,
  );

  @override
  Future<List<SemesterModel>> getSemesters() async {
    final semesters = _semestersBox.values.toList();
    semesters.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return semesters;
  }

  @override
  Future<void> saveSemesters(List<SemesterModel> semesters) async {
    await _semestersBox.clear();
    final map = {for (var e in semesters) e.id: e};
    await _semestersBox.putAll(map);
  }

  @override
  Future<void> addSemester(SemesterModel semester) async {
    await _semestersBox.put(semester.id, semester);
  }

  @override
  Future<void> deleteSemester(String semesterId) async {
    await _semestersBox.delete(semesterId);
  }

  @override
  Future<List<SubjectModel>> getSubjects() async {
    final subjects = _subjectsBox.values.toList();
    subjects.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return subjects;
  }

  @override
  Future<void> saveSubjects(List<SubjectModel> subjects) async {
    await _subjectsBox.clear();
    final map = {for (var e in subjects) e.id: e};
    await _subjectsBox.putAll(map);
  }

  @override
  Future<void> addSubject(SubjectModel subject) async {
    await _subjectsBox.put(subject.id, subject);
  }

  @override
  Future<void> updateSubject(SubjectModel subject) async {
    await _subjectsBox.put(subject.id, subject);
  }

  @override
  Future<void> deleteSubject(String subjectId) async {
    await _subjectsBox.delete(subjectId);
  }

  @override
  Future<void> deleteSubjectsBySemester(String semesterId) async {
    final toDelete = _subjectsBox.values
        .where((s) => s.semesterId == semesterId)
        .map((s) => s.id)
        .toList();
    await _subjectsBox.deleteAll(toDelete);
  }

  @override
  Future<List<SyncActionModel>> getSyncQueue() async {
    final queue = _syncQueueBox.values.toList();
    queue.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return queue;
  }

  @override
  Future<void> addToSyncQueue(SyncActionModel action) async {
    await _syncQueueBox.put(action.id, action);
  }

  @override
  Future<void> removeFromSyncQueue(String actionId) async {
    await _syncQueueBox.delete(actionId);
  }
}
