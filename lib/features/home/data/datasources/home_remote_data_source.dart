import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/semester_model.dart';
import '../models/subject_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<SemesterModel>> getSemesters(String userId);
  Future<void> addSemester(SemesterModel semester);
  Future<void> updateSemester(SemesterModel semester);
  Future<void> deleteSemester(String semesterId);

  Future<List<SubjectModel>> getSubjects(String userId);
  Future<void> addSubject(SubjectModel subject);
  Future<void> updateSubject(SubjectModel subject);
  Future<void> deleteSubject(String subjectId);

  Future<void> syncProfileCGPA(String userId, double cgpa, int totalCredits);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient _supabase;

  HomeRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<SemesterModel>> getSemesters(String userId) async {
    final response = await _supabase
        .from('semesters')
        .select()
        .eq('user_id', userId)
        .order('order_index', ascending: true);
        
    return (response as List).map((e) => SemesterModel.fromJson(e)).toList();
  }

  @override
  Future<void> addSemester(SemesterModel semester) async {
    await _supabase.from('semesters').insert(semester.toJson());
  }

  @override
  Future<void> updateSemester(SemesterModel semester) async {
    await _supabase.from('semesters').update({'name': semester.name}).eq('id', semester.id);
  }

  @override
  Future<void> deleteSemester(String semesterId) async {
    await _supabase.from('semesters').delete().eq('id', semesterId);
  }

  @override
  Future<List<SubjectModel>> getSubjects(String userId) async {
    final response = await _supabase
        .from('subjects')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List).map((e) => SubjectModel.fromJson(e)).toList();
  }

  @override
  Future<void> addSubject(SubjectModel subject) async {
    await _supabase.from('subjects').insert(subject.toJson());
  }

  @override
  Future<void> updateSubject(SubjectModel subject) async {
    await _supabase.from('subjects').update(subject.toJson()).eq('id', subject.id);
  }

  @override
  Future<void> deleteSubject(String subjectId) async {
    await _supabase.from('subjects').delete().eq('id', subjectId);
  }

  @override
  Future<void> syncProfileCGPA(String userId, double cgpa, int totalCredits) async {
    await _supabase.from('profiles').update({
      'cgpa': cgpa,
      'total_credits': totalCredits,
    }).eq('id', userId);
  }
}
