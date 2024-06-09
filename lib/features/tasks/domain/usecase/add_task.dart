import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/repository/task_repository.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

class AddTask implements UseCase<TaskEntity, AddTaskParams> {
  final TaskRepository _repository;
  AddTask(this._repository);

  @override
  Future<Either<Failure, TaskEntity>> call(AddTaskParams params) async {
    return await _repository.add(params);
  }
}

class AddTaskParams {
  String content;
  String description;
  String projectId;
  String sectionId;
  int priority;

  AddTaskParams({
    required this.content,
    required this.description,
    required this.projectId,
    required this.sectionId,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "description": description,
      "project_id": projectId,
      "section_id": sectionId,
      "priority": priority,
    };
  }
}
