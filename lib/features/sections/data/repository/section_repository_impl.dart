import 'package:fpdart/fpdart.dart';
import '../../../../common/app_string.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../common/network/connection_checker.dart';
import '../../domain/entity/section_entity.dart';
import '../../domain/repository/section_repository.dart';
import '../../domain/usecase/update_section.dart';
import '../datasource/section_local_datasource.dart';
import '../datasource/section_remote_datasource.dart';

class SectionRepositoryImpl implements SectionRepository {
  final SectionRemoteDataSource remoteDataSource;
  final SectionLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  SectionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, SectionEntity>> add(String name) async {
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
  Future<Either<Failure, SectionEntity>> update(
      UpdateSectionParams params) async {
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
  Future<Either<Failure, SectionEntity>> get(String id) async {
    try {
      var result = await remoteDataSource.get(id);
      return Right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SectionEntity>>> getAll() async {
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
  Either<Failure, List<SectionEntity>> getAllByProjectId(String id) {
    try {
      var result = localDataSource.getAllByProjectId(id);
      return Right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
