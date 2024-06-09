import 'package:fpdart/fpdart.dart';

import '../../../../common/errors/failure.dart';
import '../entity/section_entity.dart';
import '../usecase/update_section.dart';

abstract interface class SectionRepository {
  Future<Either<Failure, SectionEntity>> add(String name);
  Future<Either<Failure, SectionEntity>> update(UpdateSectionParams params);
  Future<Either<Failure, SectionEntity>> get(String id);
  Future<Either<Failure, List<SectionEntity>>> getAll();
  Future<Either<Failure, String>> delete(String id);
}
