import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/entitiy/completed_tasks_entity.dart';
import 'package:itodo/features/tasks/domain/repository/task_repository.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

class GetCompletedTasks implements UseCase<CompletedTasksEntity, NoParams> {
  final TaskRepository _repository;
  GetCompletedTasks(this._repository);

  @override
  Future<Either<Failure, CompletedTasksEntity>> call(NoParams params) async {
    return await _repository.getAllCompletedTask();
  }
}
