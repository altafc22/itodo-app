import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/project_entity.dart';
import '../repository/project_repository.dart';

class UpdateProject implements UseCase<ProjectEntity, UpdateProjectParams> {
  final ProjectRepository _repository;
  UpdateProject(this._repository);

  @override
  Future<Either<Failure, ProjectEntity>> call(UpdateProjectParams param) async {
    return await _repository.update(param);
  }
}

class UpdateProjectParams {
  String id;
  String name;

  UpdateProjectParams({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
