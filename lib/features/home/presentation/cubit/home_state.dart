import '../../domain/entities/semester_entity.dart';
import '../../data/models/subject_model.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<SemesterEntity> semesters;
  final double cgpa;
  final int totalCredits;
  final double maxGpa;

  const HomeLoaded({
    required this.semesters,
    required this.cgpa,
    required this.totalCredits,
    required this.maxGpa,
  });
  
  List<SubjectModel> get allSubjects => semesters.expand((s) => s.subjects).toList();

  HomeLoaded copyWith({
    List<SemesterEntity>? semesters,
    double? cgpa,
    int? totalCredits,
    double? maxGpa,
  }) {
    return HomeLoaded(
      semesters: semesters ?? this.semesters,
      cgpa: cgpa ?? this.cgpa,
      totalCredits: totalCredits ?? this.totalCredits,
      maxGpa: maxGpa ?? this.maxGpa,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
