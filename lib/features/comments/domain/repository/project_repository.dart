import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/comments/domain/usecase/add_comment.dart';

import '../../../../common/errors/failure.dart';
import '../entity/comment_entity.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, CommentEntity>> add(AddCommentParams param);
  Future<Either<Failure, List<CommentEntity>>> getAll(String taskId);
}
