import '../../../../config/routes/app_routes.dart';
import '../../../../gpa_calculator_app.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'home_state.dart';
import '../../domain/entities/semester_entity.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';
import '../../domain/usecases/home_usecases.dart';
import '../../../settings/domain/usecases/get_profile_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final ManageSemesterUseCase _manageSemesterUseCase;
  final ManageSubjectUseCase _manageSubjectUseCase;
  final CalculateAndSyncCGPAUseCase _calculateAndSyncCGPAUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final AuthRepository _authRepository;

  String? _currentUserId;

  HomeCubit(
    this._getHomeDataUseCase,
    this._manageSemesterUseCase,
    this._manageSubjectUseCase,
    this._calculateAndSyncCGPAUseCase,
    this._getProfileUseCase,
    this._authRepository,
  ) : super(const HomeInitial());

  Future<void> loadData() async {
    emit(const HomeLoading());

    final userResult = await _authRepository.getCurrentUser();

    await userResult.when(
      success: (user) async {
        if (user != null) {
          _currentUserId = user.id;
          await _fetchDataForUser(user.id);
        } else {
          emit(const HomeError('User not logged in'));
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      failure: (error) {
        emit(HomeError(error.message));
      },
    );
  }

  Future<void> _fetchDataForUser(String userId) async {
    final homeDataResult = await _getHomeDataUseCase(userId);
    final profileResult = await _getProfileUseCase(userId);

    homeDataResult.when(
      success: (entities) {
        profileResult.when(
          success: (profile) {
            double maxGpa = 4.0;
            if (profile.gradingScale.isNotEmpty) {
              maxGpa = profile.gradingScale
                  .map((s) => s.gpa)
                  .reduce((curr, next) => curr > next ? curr : next);
            }

            emit(
              HomeLoaded(
                semesters: entities,
                cgpa: profile.cgpa,
                totalCredits: profile.totalCredits,
                maxGpa: maxGpa,
              ),
            );
          },
          failure: (error) => emit(HomeError(error.message)),
        );
      },
      failure: (error) => emit(HomeError(error.message)),
    );
  }

  Future<void> addSemester(String name) async {
    if (_currentUserId == null || state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final newSemester = SemesterModel(
      id: const Uuid().v4(),
      userId: _currentUserId!,
      name: name,
      orderIndex: currentState.semesters.length,
      createdAt: DateTime.now(),
    );

    final newEntity = SemesterEntity(semester: newSemester, subjects: []);
    final updatedSemesters = List<SemesterEntity>.from(currentState.semesters)
      ..add(newEntity);

    emit(currentState.copyWith(semesters: updatedSemesters));

    final result = await _manageSemesterUseCase.add(newSemester);

    result.when(
      success: (_) {},
      failure: (error) {
        emit(HomeError(error.message));
        emit(currentState);
      },
    );
  }

  Future<void> deleteSemester(String semesterId) async {
    if (_currentUserId == null || state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    final updatedSemesters = currentState.semesters
        .where((e) => e.semester.id != semesterId)
        .toList();

    emit(currentState.copyWith(semesters: updatedSemesters));

    final result = await _manageSemesterUseCase.delete(semesterId);

    result.when(
      success: (_) => _recalculateCgpa(),
      failure: (error) {
        emit(HomeError(error.message));
        emit(currentState);
      },
    );
  }

  Future<void> addSubject(SubjectModel subject) async {
    if (_currentUserId == null || state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    final updatedSemesters = currentState.semesters.map((entity) {
      if (entity.semester.id == subject.semesterId) {
        return SemesterEntity(
          semester: entity.semester,
          subjects: List<SubjectModel>.from(entity.subjects)..add(subject),
        );
      }
      return entity;
    }).toList();

    emit(currentState.copyWith(semesters: updatedSemesters));

    final result = await _manageSubjectUseCase.add(subject);

    result.when(
      success: (_) => _recalculateCgpa(),
      failure: (error) {
        emit(HomeError(error.message));
        emit(currentState);
      },
    );
  }

  Future<void> deleteSubject(String subjectId) async {
    if (_currentUserId == null || state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    final updatedSemesters = currentState.semesters.map((entity) {
      if (entity.subjects.any((s) => s.id == subjectId)) {
        return SemesterEntity(
          semester: entity.semester,
          subjects: entity.subjects.where((s) => s.id != subjectId).toList(),
        );
      }
      return entity;
    }).toList();

    emit(currentState.copyWith(semesters: updatedSemesters));

    final result = await _manageSubjectUseCase.delete(subjectId);

    result.when(
      success: (_) => _recalculateCgpa(),
      failure: (error) {
        emit(HomeError(error.message));
        emit(currentState);
      },
    );
  }

  Future<void> _recalculateCgpa() async {
    if (_currentUserId == null || state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;

    final profileResult = await _getProfileUseCase(_currentUserId!);

    await profileResult.when(
      success: (profile) async {
        final result = await _calculateAndSyncCGPAUseCase(
          userId: _currentUserId!,
          allSubjects: currentState.allSubjects,
          gradingScale: profile.gradingScale,
        );

        result.when(
          success: (data) {
            emit(
              currentState.copyWith(
                cgpa: data['cgpa'] as double,
                totalCredits: data['totalCredits'] as int,
              ),
            );
          },
          failure: (error) {},
        );
      },
      failure: (error) {},
    );
  }
}
