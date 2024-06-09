import 'package:fpdart/fpdart.dart';
import 'package:itodo/common/errors/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/section_repository.dart';

class DeleteSection implements UseCase<String, String> {
  final SectionRepository _repository;
  DeleteSection(this._repository);

  @override
  Future<Either<Failure, String>> call(String id) async {
    return await _repository.delete(id);
  }
}
