import '../../domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.taskId,
    super.projectId,
    required super.content,
    required super.postedAt,
    super.attachment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      taskId: json['task_id'],
      projectId: json['project_id'],
      content: json['content'],
      postedAt: json['posted_at'],
      attachment: json['attachment'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['task_id'] = taskId;
    data['project_id'] = projectId;
    data['content'] = content;
    data['posted_at'] = postedAt;
    data['attachment'] = attachment;

    return data;
  }
}
