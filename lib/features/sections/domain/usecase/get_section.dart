import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/section_entity.dart';
import '../repository/section_repository.dart';

class GetSection implements UseCase<SectionEntity, String> {
  final SectionRepository _repository;
  GetSection(this._repository);

  @override
  Future<Either<Failure, SectionEntity>> call(String id) async {
    return await _repository.get(id);
  }
}
