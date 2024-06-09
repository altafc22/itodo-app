import 'due_entity.dart';
import 'duration_entity.dart';

class TaskEntity {
  final String id;
  final String? assignerId;
  final String? assigneeId;
  final String projectId;
  final String sectionId;
  final String? parentId;
  final int order;
  final String content;
  final String description;
  final bool isCompleted;
  final List<String> labels;
  final int priority;
  final int commentCount;
  final String creatorId;
  final DateTime createdAt;
  final DueEntity? due;
  final String url;
  final DurationEntity? duration;
  bool isInProgress = false;

  TaskEntity({
    required this.id,
    this.assignerId,
    this.assigneeId,
    required this.projectId,
    required this.sectionId,
    this.parentId,
    required this.order,
    required this.content,
    this.description = '',
    required this.isCompleted,
    this.labels = const [],
    required this.priority,
    required this.commentCount,
    required this.creatorId,
    required this.createdAt,
    this.due,
    required this.url,
    this.duration,
  });
}
