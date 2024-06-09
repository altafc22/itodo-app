part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentEntity> items;

  const CommentLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class CommentSuccess extends CommentState {
  final CommentEntity item;

  const CommentSuccess(this.item);

  @override
  List<Object> get props => [item];
}

class CommentSuccessMessage extends CommentState {
  final String message;

  const CommentSuccessMessage(this.message);

  @override
  List<Object> get props => [message];
}

class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object> get props => [message];
}
