import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/section_entity.dart';
import '../repository/section_repository.dart';

class UpdateSection implements UseCase<SectionEntity, UpdateSectionParams> {
  final SectionRepository _repository;
  UpdateSection(this._repository);

  @override
  Future<Either<Failure, SectionEntity>> call(UpdateSectionParams param) async {
    return await _repository.update(param);
  }
}

class UpdateSectionParams {
  String id;
  String name;

  UpdateSectionParams({
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
