import 'package:fpdart/fpdart.dart';
import 'package:itodo/common/errors/failure.dart';
import 'package:itodo/core/usecase/usecase.dart';
import '../entity/section_entity.dart';
import '../repository/section_repository.dart';

class AddSection implements UseCase<SectionEntity, String> {
  final SectionRepository _repository;
  AddSection(this._repository);

  @override
  Future<Either<Failure, SectionEntity>> call(String name) async {
    return await _repository.add(name);
  }
}
