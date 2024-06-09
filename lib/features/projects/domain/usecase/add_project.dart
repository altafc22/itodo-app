import 'package:fpdart/fpdart.dart';
import 'package:itodo/common/errors/failure.dart';
import 'package:itodo/core/usecase/usecase.dart';
import 'package:itodo/features/projects/domain/entity/project_entity.dart';
import 'package:itodo/features/projects/domain/repository/project_repository.dart';

class AddProject implements UseCase<ProjectEntity, String> {
  final ProjectRepository _repository;
  AddProject(this._repository);

  @override
  Future<Either<Failure, ProjectEntity>> call(String name) async {
    return await _repository.add(name);
  }
}
