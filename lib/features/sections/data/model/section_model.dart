import '../../domain/entity/section_entity.dart';

class SectionModel extends SectionEntity {
  SectionModel({
    required super.id,
    required super.projectId,
    required super.name,
    required super.order,
  });

  SectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    order = json['order'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['order'] = order;
    data['name'] = name;
    return data;
  }
}
