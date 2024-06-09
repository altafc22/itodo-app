import 'package:fpdart/fpdart.dart';
import 'package:itodo/features/projects/domain/entity/project_entity.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/project_repository.dart';

class GetAllProjects implements UseCase<List<ProjectEntity>, NoParams> {
  final ProjectRepository _repository;
  GetAllProjects(this._repository);

  @override
  Future<Either<Failure, List<ProjectEntity>>> call(NoParams params) async {
    return await _repository.getAll();
  }
}
