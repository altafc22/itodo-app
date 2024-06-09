import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/comments/domain/usecase/add_comment.dart';
import '../../../../common/app_string.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/connection_checker.dart';
import '../../domain/entity/comment_entity.dart';
import '../../domain/repository/project_repository.dart';
import '../datasource/comment_remote_datasource.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  final ConnectionChecker connectionChecker;

  CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, CommentEntity>> add(AddCommentParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.add(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getAll(String taskId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return const Right([]);
      }
      var result = await remoteDataSource.getAll(taskId);

      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
