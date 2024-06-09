import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/entitiy/completed_tasks_entity.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/usecase/add_task.dart';
import 'package:itodo/features/tasks/domain/usecase/reorder_task.dart';
import 'package:itodo/features/tasks/domain/usecase/update_task.dart';

import '../../../../common/errors/failure.dart';
import '../usecase/move_task.dart';

abstract interface class TaskRepository {
  Future<Either<Failure, TaskEntity>> add(AddTaskParams params);
  Future<Either<Failure, TaskEntity>> update(UpdateTaskParams params);
  Future<Either<Failure, TaskEntity>> get(String id);
  Future<Either<Failure, List<TaskEntity>>> getAll();
  Future<Either<Failure, String>> reopen(String id);
  Future<Either<Failure, String>> delete(String id);
  Future<Either<Failure, String>> close(String id);
  Future<Either<Failure, String>> move(MoveTaskParams params);
  Future<Either<Failure, String>> reorder(List<ReorderTasksParams> params);

  Either<Failure, List<TaskEntity>> getAllByProjectId(String id);
  Future<Either<Failure, CompletedTasksEntity>> getAllCompletedTask();
}
