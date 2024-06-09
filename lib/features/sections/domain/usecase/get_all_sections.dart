import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/section_entity.dart';
import '../repository/section_repository.dart';

class GetAllSections implements UseCase<List<SectionEntity>, NoParams> {
  final SectionRepository _repository;
  GetAllSections(this._repository);

  @override
  Future<Either<Failure, List<SectionEntity>>> call(NoParams params) async {
    return await _repository.getAll();
  }

  Either<Failure, List<SectionEntity>> getAllByProjectId(String id) {
    return _repository.getAllByProjectId(id);
  }
}
