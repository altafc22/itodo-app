import 'package:fpdart/fpdart.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/features/tasks/domain/entitiy/completed_tasks_entity.dart';
import 'package:itodo/features/tasks/domain/usecase/add_task.dart';
import 'package:itodo/features/tasks/domain/usecase/reorder_task.dart';
import 'package:itodo/features/tasks/domain/usecase/update_task.dart';

import '../../../../common/app_string.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/connection_checker.dart';
import '../../domain/entitiy/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../../domain/usecase/move_task.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, TaskEntity>> add(AddTaskParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.add(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> update(UpdateTaskParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.update(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> delete(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.delete(id);
      printInfo("ID in delete: $id");
      localDataSource.deleteLocalTask(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> get(String id) async {
    try {
      var result = await remoteDataSource.get(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAll() async {
    try {
      if (!await connectionChecker.isConnected) {
        final items = localDataSource.getAll();
        return Right(items);
      }
      var result = await remoteDataSource.getAll();
      localDataSource.insert(items: result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> reopen(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.reopen(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> close(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.close(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Either<Failure, List<TaskEntity>> getAllByProjectId(String id) {
    try {
      var result = localDataSource.getAllByProjectId(id);
      return Right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> move(MoveTaskParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.move(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> reorder(
      List<ReorderTasksParams> params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.reorder(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, CompletedTasksEntity>> getAllCompletedTask() async {
    try {
      if (!await connectionChecker.isConnected) {
        final result = localDataSource.getAllCompleted();
        return Right(result);
      }
      var result = await remoteDataSource.getCompletedTasks();
      localDataSource.saveCompletedTasks(result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
