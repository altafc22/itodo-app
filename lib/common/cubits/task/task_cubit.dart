import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:itodo/core/usecase/usecase.dart';
import 'package:itodo/features/tasks/domain/entitiy/completed_tasks_entity.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/usecase/delete_task.dart';
import 'package:itodo/features/tasks/domain/usecase/get_all_completed_tasks.dart';
import 'package:itodo/features/tasks/domain/usecase/get_all_tasks.dart';
import 'package:itodo/features/tasks/domain/usecase/get_task.dart';
import 'package:itodo/features/tasks/domain/usecase/move_task.dart';
import 'package:itodo/features/tasks/domain/usecase/reorder_task.dart';
import 'package:itodo/features/tasks/domain/usecase/update_task.dart';

import '../../../features/tasks/domain/usecase/add_task.dart';
import '../../../features/tasks/domain/usecase/close_task.dart';
import '../../../features/tasks/domain/usecase/reopen_task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.getAllTasksUseCase,
    required this.getTaskUseCase,
    required this.deleteTaskUseCase,
    required this.closeTaskUseCase,
    required this.reopenTaskUseCase,
    required this.moveTaskUseCase,
    required this.reorderTaskUseCase,
    required this.getCompletedTasksUseCase,
  }) : super(TaskInitial());

  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final GetAllTasks getAllTasksUseCase;
  final GetTask getTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final CloseTask closeTaskUseCase;
  final ReopenTask reopenTaskUseCase;
  final MoveTask moveTaskUseCase;
  final ReorderTasks reorderTaskUseCase;
  final GetCompletedTasks getCompletedTasksUseCase;

  void addTask(AddTaskParams params) async {
    emit(TaskLoading());
    final res = await addTaskUseCase.call(params);

    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskSuccess(r)),
    );
  }

  void updateTask(UpdateTaskParams params) async {
    emit(TaskLoading());
    final res = await updateTaskUseCase.call(params);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskSuccess(r)),
    );
  }

  void getAllTasks() async {
    emit(TaskLoading());
    final res = await getAllTasksUseCase.call(NoParams());
    res.fold((l) => emit(TaskError(l.message)), (r) => emit(TaskLoaded(r)));
  }

  void getTask(String id) async {
    emit(TaskLoading());
    final res = await getTaskUseCase.call(id);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskLoaded([r])),
    );
  }

  void deleteTask(String id) async {
    emit(TaskLoading());
    final res = await deleteTaskUseCase.call(id);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskSuccessMessage(r)),
    );
  }

  void reopenTask(String id) async {
    emit(TaskLoading());
    final res = await reopenTaskUseCase.call(id);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskSuccessMessage(r)),
    );
  }

  void closeTask(String id) async {
    emit(TaskLoading());
    final res = await closeTaskUseCase.call(id);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskSuccessMessage(r)),
    );
  }

  void getAllByProjectId(String id) async {
    emit(TaskLoading());
    final res = getAllTasksUseCase.getAllByProjectId(id);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(TaskLoaded(r)),
    );
  }

  void moveTask(MoveTaskParams item) async {
    emit(TaskLoading());
    final res = await moveTaskUseCase.call(item);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(const TaskShuffeled("Success")),
    );
  }

  void reoderItems(List<ReorderTasksParams> items) async {
    emit(TaskLoading());
    final res = await reorderTaskUseCase.call(items);
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(const TaskShuffeled("Success")),
    );
  }

  void getCompletedTasks() async {
    emit(TaskLoading());
    final res = await getCompletedTasksUseCase.call(NoParams());
    res.fold(
      (l) => emit(TaskError(l.message)),
      (r) => emit(CompletedTaskLoaded(r)),
    );
  }
}
