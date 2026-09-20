import 'dart:convert';

import '../models/sync_action_model.dart';

import 'package:workmanager/workmanager.dart';

import '../../../../core/networking/api_result.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/networking/network_info.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/semester_model.dart';
import '../models/subject_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  Future<void> _queueAction(String actionType, String payload) async {
    final action = SyncActionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actionType: actionType,
      payload: payload,
      createdAt: DateTime.now(),
    );
    await _localDataSource.addToSyncQueue(action);

    Workmanager().registerOneOffTask(
      "sync-${action.id}",
      "uploadSyncQueue",
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  @override
  Future<void> processSyncQueue() async {
    final queue = await _localDataSource.getSyncQueue();
    for (final action in queue) {
      try {
        if (action.actionType == SyncActionTypes.addSemester) {
          await _remoteDataSource.addSemester(
            SemesterModel.fromJson(jsonDecode(action.payload)),
          );
        } else if (action.actionType == SyncActionTypes.deleteSemester) {
          await _remoteDataSource.deleteSemester(action.payload);
        } else if (action.actionType == SyncActionTypes.addSubject) {
          await _remoteDataSource.addSubject(
            SubjectModel.fromJson(jsonDecode(action.payload)),
          );
        } else if (action.actionType == SyncActionTypes.updateSubject) {
          await _remoteDataSource.updateSubject(
            SubjectModel.fromJson(jsonDecode(action.payload)),
          );
        } else if (action.actionType == SyncActionTypes.deleteSubject) {
          await _remoteDataSource.deleteSubject(action.payload);
        } else if (action.actionType == SyncActionTypes.syncCgpa) {
          final data = jsonDecode(action.payload);
          await _remoteDataSource.syncProfileCGPA(
            data['userId'],
            data['cgpa'],
            data['totalCredits'],
          );
        }
        await _localDataSource.removeFromSyncQueue(action.id);
      } catch (e) {
        break;
      }
    }
  }

  @override
  Future<ApiResult<void>> syncData(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        await processSyncQueue();

        final remoteSemesters = await _remoteDataSource.getSemesters(userId);
        await _localDataSource.saveSemesters(remoteSemesters);

        final remoteSubjects = await _remoteDataSource.getSubjects(userId);
        await _localDataSource.saveSubjects(remoteSubjects);

        return const Success(null);
      } catch (e) {
        return FailureResult(ServerFailure(e.toString()));
      }
    } else {
      return const Success(null);
    }
  }

  @override
  Future<ApiResult<List<SemesterModel>>> getSemesters() async {
    try {
      final semesters = await _localDataSource.getSemesters();
      return Success(semesters);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to get semesters '));
    }
  }

  @override
  Future<ApiResult<void>> addSemester(SemesterModel semester) async {
    try {
      await _localDataSource.addSemester(semester);

      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.addSemester(semester);
        } catch (e) {
          await _queueAction(
            SyncActionTypes.addSemester,
            jsonEncode(semester.toJson()),
          );
        }
      } else {
        await _queueAction(
          SyncActionTypes.addSemester,
          jsonEncode(semester.toJson()),
        );
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to add the semester'));
    }
  }

  @override
  Future<ApiResult<void>> deleteSemester(String semesterId) async {
    try {
      await _localDataSource.deleteSemester(semesterId);
      await _localDataSource.deleteSubjectsBySemester(semesterId);

      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.deleteSemester(semesterId);
        } catch (e) {
          await _queueAction(SyncActionTypes.deleteSemester, semesterId);
        }
      } else {
        await _queueAction(SyncActionTypes.deleteSemester, semesterId);
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to delete semester'));
    }
  }

  @override
  Future<ApiResult<List<SubjectModel>>> getSubjects() async {
    try {
      final subjects = await _localDataSource.getSubjects();
      return Success(subjects);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to load subjects'));
    }
  }

  @override
  Future<ApiResult<void>> addSubject(SubjectModel subject) async {
    try {
      await _localDataSource.addSubject(subject);

      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.addSubject(subject);
        } catch (e) {
          await _queueAction(
            SyncActionTypes.addSubject,
            jsonEncode(subject.toJson()),
          );
        }
      } else {
        await _queueAction(
          SyncActionTypes.addSubject,
          jsonEncode(subject.toJson()),
        );
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to add subject'));
    }
  }

  @override
  Future<ApiResult<void>> updateSubject(SubjectModel subject) async {
    try {
      await _localDataSource.updateSubject(subject);

      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.updateSubject(subject);
        } catch (e) {
          await _queueAction(
            SyncActionTypes.updateSubject,
            jsonEncode(subject.toJson()),
          );
        }
      } else {
        await _queueAction(
          SyncActionTypes.updateSubject,
          jsonEncode(subject.toJson()),
        );
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to update subject'));
    }
  }

  @override
  Future<ApiResult<void>> deleteSubject(String subjectId) async {
    try {
      await _localDataSource.deleteSubject(subjectId);

      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.deleteSubject(subjectId);
        } catch (e) {
          await _queueAction(SyncActionTypes.deleteSubject, subjectId);
        }
      } else {
        await _queueAction(SyncActionTypes.deleteSubject, subjectId);
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to delete subject'));
    }
  }

  @override
  Future<ApiResult<void>> syncProfileCGPA(
    String userId,
    double cgpa,
    int totalCredits,
  ) async {
    final payload = jsonEncode({
      'userId': userId,
      'cgpa': cgpa,
      'totalCredits': totalCredits,
    });
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.syncProfileCGPA(userId, cgpa, totalCredits);
        return const Success(null);
      } catch (e) {
        await _queueAction(SyncActionTypes.syncCgpa, payload);
        return const Success(null);
      }
    }

    await _queueAction(SyncActionTypes.syncCgpa, payload);
    return const Success(null);
  }
}
