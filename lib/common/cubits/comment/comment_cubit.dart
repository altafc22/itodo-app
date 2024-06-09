import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/comments/domain/entity/comment_entity.dart';
import '../../../features/comments/domain/usecase/add_comment.dart';
import '../../../features/comments/domain/usecase/get_all_comments.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({
    required this.addCommentUseCase,
    required this.getAllCommentsUseCase,
  }) : super(CommentInitial());

  final AddComment addCommentUseCase;
  final GetAllComments getAllCommentsUseCase;

  void addComment(AddCommentParams params) async {
    emit(CommentLoading());
    final res = await addCommentUseCase.call(params);
    res.fold(
      (l) => emit(CommentError(l.message)),
      (r) => emit(CommentSuccess(r)),
    );
  }

  void getAllComments(String taskId) async {
    emit(CommentLoading());
    final res = await getAllCommentsUseCase.call(taskId);
    res.fold(
        (l) => emit(CommentError(l.message)), (r) => emit(CommentLoaded(r)));
  }
}
