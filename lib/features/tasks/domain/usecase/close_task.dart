import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/task_repository.dart';

class CloseTask implements UseCase<String, String> {
  final TaskRepository _repository;
  CloseTask(this._repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await _repository.close(params);
  }
}
