import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/repository/task_repository.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

class ReorderTasks implements UseCase<String, List<ReorderTasksParams>> {
  final TaskRepository _repository;
  ReorderTasks(this._repository);

  @override
  Future<Either<Failure, String>> call(List<ReorderTasksParams> params) async {
    return await _repository.reorder(params);
  }
}

class ReorderTasksParams {
  String id;
  int childOrder;

  ReorderTasksParams({
    required this.id,
    required this.childOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "child_order": childOrder,
    };
  }
}
