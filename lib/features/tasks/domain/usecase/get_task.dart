import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/repository/task_repository.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

class GetTask implements UseCase<TaskEntity, String> {
  final TaskRepository _repository;
  GetTask(this._repository);

  @override
  Future<Either<Failure, TaskEntity>> call(String id) async {
    return await _repository.get(id);
  }
}
