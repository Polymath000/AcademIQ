import 'dart:io';

void main() {
  var file = File('lib/features/home/presentation/views/home_view.dart');
  var content = file.readAsStringSync();

  var imports = '''import 'package:skeletonizer/skeletonizer.dart';
import '../../domain/entities/semester_entity.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';
''';

  var dummyDataMethod = '''
  List<SemesterEntity> _getDummySemesters() {
    return [
      SemesterEntity(
        semester: SemesterModel(id: '1', userId: 'mock', name: 'Semester 1', orderIndex: 0, createdAt: DateTime.now()),
        subjects: [
          SubjectModel(id: '1', semesterId: '1', userId: 'mock', name: 'Data Structures', credits: 4, gradeLetter: 'A+', createdAt: DateTime.now()),
          SubjectModel(id: '2', semesterId: '1', userId: 'mock', name: 'Discrete Math', credits: 3, gradeLetter: 'B+', createdAt: DateTime.now()),
        ],
      ),
      SemesterEntity(
        semester: SemesterModel(id: '2', userId: 'mock', name: 'Semester 2', orderIndex: 1, createdAt: DateTime.now()),
        subjects: [
          SubjectModel(id: '3', semesterId: '2', userId: 'mock', name: 'Algorithms', credits: 4, gradeLetter: 'A-', createdAt: DateTime.now()),
        ],
      ),
    ];
  }

  @override''';

  var searchBlock = '''          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }''';

  var replaceBlock = '''          if (state is HomeInitial || state is HomeLoading) {
            return Skeletonizer(
              enabled: true,
              effect: const ShimmerEffect(
                baseColor: AppColors.semesterCardBg,
                highlightColor: AppColors.cardGradientStart,
              ),
              child: HomeViewBody(
                cgpa: 3.52,
                maxGpa: 4.0,
                totalCredits: 36,
                semesters: _getDummySemesters(),
              ),
            );
          }''';

  if (!content.contains('package:skeletonizer/skeletonizer.dart')) {
    content = imports + content;
  }
  
  if (!content.contains('_getDummySemesters')) {
    content = content.replaceFirst('  @override', dummyDataMethod);
  }

  if (content.contains(searchBlock)) {
    content = content.replaceFirst(searchBlock, replaceBlock);
    file.writeAsStringSync(content);
    print("Success!");
  } else {
    print("Search block not found!");
  }
}
