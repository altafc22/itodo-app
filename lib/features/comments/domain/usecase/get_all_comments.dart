import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/comment_entity.dart';
import '../repository/project_repository.dart';

class GetAllComments implements UseCase<List<CommentEntity>, String> {
  final CommentRepository _repository;
  GetAllComments(this._repository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(String taskId) async {
    return await _repository.getAll(taskId);
  }
}
