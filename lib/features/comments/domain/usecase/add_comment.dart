import 'package:fpdart/fpdart.dart';
import 'package:itodo/common/errors/failure.dart';
import 'package:itodo/core/usecase/usecase.dart';

import '../entity/comment_entity.dart';
import '../repository/project_repository.dart';

class AddComment implements UseCase<CommentEntity, AddCommentParams> {
  final CommentRepository _repository;
  AddComment(this._repository);

  @override
  Future<Either<Failure, CommentEntity>> call(AddCommentParams param) async {
    return await _repository.add(param);
  }
}

class AddCommentParams {
  String content;
  String taskId;
  String projectId;

  AddCommentParams({
    required this.content,
    required this.taskId,
    required this.projectId,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "task_id": taskId,
      "project_id": projectId,
    };
  }
}
