import '../../data/models/profile_model.dart';
import '../../data/models/grading_scale_model.dart';

class SettingsMocks {
  SettingsMocks._();

  static ProfileModel get dummyProfile => ProfileModel(
        id: '',
        fullName: 'Loading User Name',
        email: 'loading.user@email.com',
        gradingScale: [],
      );

  static List<GradingScaleModel> get dummyGradingScale => [
        GradingScaleModel(letter: 'A+', gpa: 4.0, minScore: 90, enable: true),
        GradingScaleModel(letter: 'A', gpa: 3.67, minScore: 85, enable: true),
        GradingScaleModel(letter: 'A-', gpa: 3.33, minScore: 80, enable: false),
        GradingScaleModel(letter: 'B+', gpa: 3.0, minScore: 75, enable: true),
        GradingScaleModel(letter: 'B', gpa: 2.67, minScore: 70, enable: true),
      ];
}
