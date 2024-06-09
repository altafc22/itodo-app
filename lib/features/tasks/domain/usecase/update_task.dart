import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entitiy/task_entity.dart';
import '../repository/task_repository.dart';

class UpdateTask implements UseCase<TaskEntity, UpdateTaskParams> {
  final TaskRepository _repository;
  UpdateTask(this._repository);

  @override
  Future<Either<Failure, TaskEntity>> call(UpdateTaskParams params) async {
    return await _repository.update(params);
  }
}

class UpdateTaskParams {
  String id;
  String content;
  String description;
  List<String> labels;
  int priority;
  String dueString;
  String dueDate;
  String dueDatetime;
  String dueLang;
  String assigneeId;
  int? duration;
  String? durationUnit;

  UpdateTaskParams({
    required this.id,
    this.content = "",
    this.description = "",
    this.labels = const [],
    this.priority = 1,
    this.dueString = "",
    this.dueDate = "",
    this.dueDatetime = "",
    this.dueLang = "",
    this.assigneeId = "",
    this.duration,
    this.durationUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "description": description,
      "labels": labels,
      "priority": priority,
      "due_string": dueString,
      "due_date": dueDate,
      "due_datetime": dueDatetime,
      "due_lang": dueLang,
      "assignee_id": assigneeId.isEmpty ? null : assigneeId,
      "duration": duration,
      "duration_unit": durationUnit,
    };
  }
}
