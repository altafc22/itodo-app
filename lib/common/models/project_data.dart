import '../../features/projects/domain/entity/project_entity.dart';

import 'section_data.dart';

class ProjectData {
  final ProjectEntity project;
  final List<SectionData> sections;

  ProjectData({required this.project, required this.sections});
}
