import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/projects/data/datasource/project_remote_datasource.dart';
import 'package:itodo/features/projects/domain/repository/project_repository.dart';
import 'package:itodo/features/projects/domain/usecase/update_project.dart';
import '../../../../common/app_string.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/connection_checker.dart';
import '../../domain/entity/project_entity.dart';
import '../datasource/project_local_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, ProjectEntity>> add(String name) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.add(name);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> update(
      UpdateProjectParams params) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.update(params);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> delete(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(AppString.noInternetConnection));
      }
      var result = await remoteDataSource.delete(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> get(String id) async {
    try {
      var result = await remoteDataSource.get(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getAll() async {
    try {
      if (!await connectionChecker.isConnected) {
        final items = localDataSource.getAll();
        return Right(items);
      }
      var result = await remoteDataSource.getAll();
      localDataSource.insert(items: result);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Either<Failure, ProjectEntity> getLocalProjectById(String id) {
    try {
      var result = localDataSource.getById(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
