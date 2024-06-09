import 'package:itodo/features/projects/domain/entity/project_entity.dart';

class ProjectModel extends ProjectEntity {
  ProjectModel({
    required super.id,
    required super.name,
    required super.commentcount,
    required super.order,
    required super.color,
    required super.isshared,
    required super.isfavorite,
    required super.parentid,
    required super.isinboxproject,
    required super.isteaminbox,
    required super.viewstyle,
    required super.url,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    commentcount = json['comment_count'];
    order = json['order'];
    color = json['color'];
    isshared = json['is_shared'];
    isfavorite = json['is_favorite'];
    parentid = json['parent_id'];
    isinboxproject = json['is_inbox_project'];
    isteaminbox = json['is_team_inbox'];
    viewstyle = json['view_style'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['comment_count'] = commentcount;
    data['order'] = order;
    data['color'] = color;
    data['is_shared'] = isshared;
    data['is_favorite'] = isfavorite;
    data['parent_id'] = parentid;
    data['is_inbox_project'] = isinboxproject;
    data['is_team_inbox'] = isteaminbox;
    data['view_style'] = viewstyle;
    data['url'] = url;
    return data;
  }
}
