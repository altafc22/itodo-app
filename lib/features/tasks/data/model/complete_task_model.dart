import 'package:itodo/features/tasks/domain/entitiy/completed_tasks_entity.dart';

class CompletedItemModel extends CompletedItemEntity {
  CompletedItemModel({
    required super.content,
    required super.userId,
    required super.taskId,
    required super.noteCount,
    required super.projectId,
    required super.sectionId,
    required super.completedAt,
    required super.id,
  });

  factory CompletedItemModel.fromJson(Map<String, dynamic> json) {
    return CompletedItemModel(
      content: json['content'],
      userId: json['user_id'],
      taskId: json['task_id'],
      noteCount: json['note_count'],
      projectId: json['project_id'],
      sectionId: json['section_id'],
      completedAt: json['completed_at'],
      id: json['id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

class CompletedProjectModel extends CompletedProjectEntity {
  CompletedProjectModel({
    required super.color,
    required super.collapsed,
    super.parentId,
    required super.isDeleted,
    required super.id,
    required super.userId,
    required super.name,
    required super.childOrder,
    required super.isArchived,
    required super.viewStyle,
  });

  factory CompletedProjectModel.fromJson(Map<String, dynamic> json) {
    return CompletedProjectModel(
      color: json['color'],
      collapsed: json['collapsed'],
      parentId: json['parent_id'],
      isDeleted: json['is_deleted'],
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      childOrder: json['child_order'],
      isArchived: json['is_archived'],
      viewStyle: json['view_style'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

class CompletedSectionModel extends CompletedSectionEntity {
  CompletedSectionModel({
    required super.collapsed,
    required super.addedAt,
    archivedAt,
    required super.id,
    required super.isArchived,
    required super.isDeleted,
    required super.name,
    required super.projectId,
    required super.sectionOrder,
    syncId,
    required super.userId,
  });

  factory CompletedSectionModel.fromJson(Map<String, dynamic> json) {
    return CompletedSectionModel(
      collapsed: json['collapsed'],
      addedAt: json['added_at'],
      archivedAt: json['archived_at'],
      id: json['id'],
      isArchived: json['is_archived'],
      isDeleted: json['is_deleted'],
      name: json['name'],
      projectId: json['project_id'],
      sectionOrder: json['section_order'],
      syncId: json['sync_id'],
      userId: json['user_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

class CompletedTasksModel extends CompletedTasksEntity {
  CompletedTasksModel({
    required super.items,
    required super.projects,
    required super.sections,
  });

  factory CompletedTasksModel.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List;
    List<CompletedItemModel> items =
        itemList.map((i) => CompletedItemModel.fromJson(i)).toList();

    Map<String, CompletedProjectModel> projects = {};
    json['projects'].forEach((key, value) {
      projects[key] = CompletedProjectModel.fromJson(value);
    });

    Map<String, CompletedSectionModel> sections = {};
    json['sections'].forEach((key, value) {
      sections[key] = CompletedSectionModel.fromJson(value);
    });

    return CompletedTasksModel(
      items: items,
      projects: projects,
      sections: sections,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
