import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/projects/domain/entity/project_entity.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/project_repository.dart';

class GetProject implements UseCase<ProjectEntity, String> {
  final ProjectRepository _repository;
  GetProject(this._repository);

  @override
  Future<Either<Failure, ProjectEntity>> call(String id) async {
    return await _repository.get(id);
  }

  Either<Failure, ProjectEntity> callLocal(String id) {
    return _repository.getLocalProjectById(id);
  }
}
