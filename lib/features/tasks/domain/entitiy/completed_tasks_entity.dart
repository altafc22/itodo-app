class CompletedItemEntity {
  String content;
  String? userId;
  String? taskId;
  int noteCount;
  String? projectId;
  String? sectionId;
  String? completedAt;
  String? id;

  CompletedItemEntity({
    required this.content,
    required this.userId,
    required this.taskId,
    required this.noteCount,
    required this.projectId,
    required this.sectionId,
    required this.completedAt,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'user_id': userId,
      'task_id': taskId,
      'note_count': noteCount,
      'project_id': projectId,
      'section_id': sectionId,
      'completed_at': completedAt,
      'id': id,
    };
  }
}

class CompletedProjectEntity {
  String? color;
  bool collapsed;
  String? parentId;
  bool isDeleted;
  String? id;
  String? userId;
  String? name;
  int childOrder;
  bool isArchived;
  String? viewStyle;

  CompletedProjectEntity({
    required this.color,
    required this.collapsed,
    this.parentId,
    required this.isDeleted,
    required this.id,
    required this.userId,
    required this.name,
    required this.childOrder,
    required this.isArchived,
    required this.viewStyle,
  });

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'collapsed': collapsed,
      'parent_id': parentId,
      'is_deleted': isDeleted,
      'id': id,
      'user_id': userId,
      'name': name,
      'child_order': childOrder,
      'is_archived': isArchived,
      'view_style': viewStyle,
    };
  }
}

class CompletedSectionEntity {
  bool collapsed;
  String? addedAt;
  String? archivedAt;
  String? id;
  bool isArchived;
  bool isDeleted;
  String? name;
  String? projectId;
  int sectionOrder;
  String? syncId;
  String? userId;

  CompletedSectionEntity({
    required this.collapsed,
    required this.addedAt,
    this.archivedAt,
    required this.id,
    required this.isArchived,
    required this.isDeleted,
    required this.name,
    required this.projectId,
    required this.sectionOrder,
    this.syncId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'collapsed': collapsed,
      'added_at': addedAt,
      'archived_at': archivedAt,
      'id': id,
      'is_archived': isArchived,
      'is_deleted': isDeleted,
      'name': name,
      'project_id': projectId,
      'section_order': sectionOrder,
      'sync_id': syncId,
      'user_id': userId,
    };
  }
}

class CompletedTasksEntity {
  List<CompletedItemEntity> items;
  Map<String, CompletedProjectEntity> projects;
  Map<String, CompletedSectionEntity> sections;

  CompletedTasksEntity({
    required this.items,
    required this.projects,
    required this.sections,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'projects':
          projects.map((key, project) => MapEntry(key, project.toJson())),
      'sections':
          sections.map((key, section) => MapEntry(key, section.toJson())),
    };
  }
}
