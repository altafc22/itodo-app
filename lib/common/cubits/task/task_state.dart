part of 'task_cubit.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> items;

  const TaskLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class TaskSuccess extends TaskState {
  final TaskEntity item;

  const TaskSuccess(this.item);

  @override
  List<Object> get props => [item];
}

class TaskSuccessMessage extends TaskState {
  final String message;

  const TaskSuccessMessage(this.message);

  @override
  List<Object> get props => [message];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskShuffeled extends TaskState {
  final String message;

  const TaskShuffeled(this.message);

  @override
  List<Object> get props => [message];
}

class CompletedTaskLoaded extends TaskState {
  const CompletedTaskLoaded(this.data);

  final CompletedTasksEntity data;

  @override
  List<Object> get props => [data];
}
