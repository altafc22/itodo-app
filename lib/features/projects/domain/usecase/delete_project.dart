import 'package:fpdart/fpdart.dart';
import 'package:itodo/common/errors/failure.dart';
import 'package:itodo/features/projects/domain/repository/project_repository.dart';

import '../../../../core/usecase/usecase.dart';

class DeleteProject implements UseCase<String, String> {
  final ProjectRepository _repository;
  DeleteProject(this._repository);

  @override
  Future<Either<Failure, String>> call(String id) async {
    return await _repository.delete(id);
  }
}
