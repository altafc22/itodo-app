import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/projects/domain/entity/project_entity.dart';

import '../../../../common/errors/failure.dart';
import '../usecase/update_project.dart';

abstract interface class ProjectRepository {
  Future<Either<Failure, ProjectEntity>> add(String name);
  Future<Either<Failure, ProjectEntity>> update(UpdateProjectParams params);
  Future<Either<Failure, ProjectEntity>> get(String id);
  Future<Either<Failure, List<ProjectEntity>>> getAll();
  Future<Either<Failure, String>> delete(String id);
  Either<Failure, ProjectEntity> getLocalProjectById(String id);
}
