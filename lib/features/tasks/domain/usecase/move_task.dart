import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/tasks/domain/repository/task_repository.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

class MoveTask implements UseCase<String, MoveTaskParams> {
  final TaskRepository _repository;
  MoveTask(this._repository);

  @override
  Future<Either<Failure, String>> call(MoveTaskParams params) async {
    return await _repository.move(params);
  }
}

class MoveTaskParams {
  String id;
  String projectId;
  String sectionId;
  String? parentId;

  MoveTaskParams({
    required this.id,
    required this.projectId,
    required this.sectionId,
    this.parentId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "section_id": sectionId,
      "project_id": projectId,
      //"parent_id": parentId
    };
  }
}
