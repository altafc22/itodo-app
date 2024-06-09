import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/repository/task_repository.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

class GetAllTasks implements UseCase<List<TaskEntity>, NoParams> {
  final TaskRepository _repository;
  GetAllTasks(this._repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) async {
    return await _repository.getAll();
  }

  Either<Failure, List<TaskEntity>> getAllByProjectId(String id) {
    return _repository.getAllByProjectId(id);
  }
}
