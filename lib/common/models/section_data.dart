import '../../features/sections/domain/entity/section_entity.dart';
import '../../features/tasks/domain/entitiy/task_entity.dart';

class SectionData {
  final SectionEntity section;
  final List<TaskEntity> tasks;

  SectionData({required this.section, required this.tasks});
}
