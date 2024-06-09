class CommentEntity {
  String id;
  String taskId;
  String? projectId;
  String content;
  String postedAt;
  String? attachment;

  CommentEntity({
    required this.id,
    required this.taskId,
    this.projectId,
    required this.content,
    required this.postedAt,
    this.attachment,
  });
}
