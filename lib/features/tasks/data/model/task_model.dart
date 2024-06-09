import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/features/tasks/data/model/due_model.dart';
import 'package:itodo/features/tasks/data/model/duration_model.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.assignerId,
    required super.assigneeId,
    required super.projectId,
    required super.sectionId,
    required super.parentId,
    required super.order,
    required super.content,
    required super.description,
    required super.isCompleted,
    required super.labels,
    required super.priority,
    required super.commentCount,
    required super.creatorId,
    required super.createdAt,
    required super.due,
    required super.url,
    required super.duration,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      assignerId: json['assigner_id'],
      assigneeId: json['assignee_id'],
      projectId: json['project_id'],
      sectionId: json['section_id'],
      parentId: json['parent_id'],
      order: json['order'],
      content: json['content'],
      description: json['description'],
      isCompleted: json['is_completed'],
      labels: List<String>.from(json['labels'] ?? []),
      priority: json['priority'],
      commentCount: json['comment_count'],
      creatorId: json['creator_id'],
      createdAt: json['created_at'].toString().toDateTime(),
      due: json['due'] != null ? DueModel.fromJson(json['due']) : null,
      url: json['url'],
      duration: json['duration'] != null
          ? DurationModel.fromJson(json['duration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assigner_id': assignerId,
      'assignee_id': assigneeId,
      'project_id': projectId,
      'section_id': sectionId,
      'parent_id': parentId,
      'order': order,
      'content': content,
      'description': description,
      'is_completed': isCompleted,
      'labels': labels,
      'priority': priority,
      'comment_count': commentCount,
      'creator_id': creatorId,
      'created_at': createdAt.toIso8601String(),
      'due': due,
      'url': url,
      'duration': duration,
    };
  }
}
