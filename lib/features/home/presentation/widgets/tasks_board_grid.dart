import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:itodo/common/cubits/task/task_cubit.dart';
import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/network/connection_checker.dart';
import 'package:itodo/common/utils/app_utils.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/common/widgets/kanban_board/board_list.dart';
import 'package:itodo/common/widgets/kanban_board/board_view_controller.dart';
import 'package:itodo/common/widgets/loading_indicator.dart';
import 'package:itodo/common/widgets/task_item_widget.dart';
import 'package:itodo/const/constants.dart';
import 'package:itodo/di.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/usecase/move_task.dart';
import 'package:itodo/features/tasks/domain/usecase/reorder_task.dart';
import 'package:itodo/features/tasks/domain/usecase/update_task.dart';
import 'package:itodo/features/tasks/presentation/screens/task_page.dart';

import '../../../../common/models/project_data.dart';
import '../../../../common/models/section_data.dart';
import '../../../../common/utils/show_toast.dart';
import '../../../../common/widgets/kanban_board/board_item.dart';
import '../../../../common/widgets/kanban_board/board_view.dart';
import '../../../../x_bloc_pack/blocs.dart';
import '../../../projects/domain/entity/project_entity.dart';
import '../../../sections/domain/entity/section_entity.dart';

class TaskBoardGrid extends StatefulWidget {
  const TaskBoardGrid({
    super.key,
    required this.data,
  });

  final ProjectData data;

  @override
  State<TaskBoardGrid> createState() => _TaskBoardGridState();
}

class _TaskBoardGridState extends State<TaskBoardGrid> {
  final boardViewController = BoardViewController();

  @override
  void initState() {
    setupConnectionChecker();
    super.initState();
  }

  late StreamSubscription<InternetStatus> connectionListener;
  final connectionChecker = serviceLocator<ConnectionChecker>();
  bool isConnected = true;
  void setupConnectionChecker() async {
    connectionListener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          printInfo("The internet is now connected");
          setState(() {
            isConnected = true;
          });
          showToast("Internet is available");
          break;
        case InternetStatus.disconnected:
          printInfo("The internet is now disconnected");
          setState(() {
            isConnected = false;
          });
          showToast("No Internet");
          break;
      }
    });
    isConnected = await connectionChecker.isConnected;
    setState(() {});
  }

  @override
  void dispose() {
    connectionListener.cancel();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    List<BoardList> lists = [];

    for (int i = 0; i < widget.data.sections.length; i++) {
      final sectionData = widget.data.sections;
      lists.add(_createBoardList(sectionData[i]));
    }

    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
        if (state is TaskShuffeled) {}
        if (state is TaskSuccess || state is TaskSuccess) {
          showToast("Success");
        }
        if (state is TaskError) {
          showToast(state.message);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.data.project.name,
                          style: theme.textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context.read<TaskCubit>().getAllTasks();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  Expanded(
                    child: BoardView(
                      lists: lists,
                      width: 295,
                      boardViewController: boardViewController,
                    ),
                  ),
                ],
              ),
            ),
            isLoading ? const LoadingIndicator() : Container()
          ],
        );
      },
    );
  }

  _createBoardList(SectionData sectionData) {
    final ThemeData theme = Theme.of(context);
    final section = sectionData.section;
    final list = sectionData.tasks;
    List<BoardItem> items = [];
    for (int i = 0; i < list.length; i++) {
      items.insert(i, _buildBoardItem(list[i]));
    }

    return BoardList(
      draggable: false,
      onStartDragList: (listIndex) {},
      onTapList: (listIndex) async {},
      onDropList: (listIndex, oldListIndex) {
        var list = widget.data.sections[oldListIndex!];
        widget.data.sections.removeAt(oldListIndex);
        widget.data.sections.insert(listIndex!, list);
      },
      listDecoration: BoxDecoration(
        color: context.read<ThemeCubit>().currentTheme == ThemeMode.dark
            ? darkGray
            : grayColor200,
        borderRadius: BorderRadius.circular(16),
      ),
      header: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: AppUtils.getSectionColor(section.name),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      section.name,
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: context.read<ThemeCubit>().currentTheme !=
                                ThemeMode.dark
                            ? Colors.black26
                            : Colors.white24,
                      ),
                      child: Text(items.length.toString(),
                          style: theme.textTheme.titleSmall!),
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: AppUtils.getSectionColor(
                                section.name,
                              ).withAlpha(100),
                              borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.add, size: 20)),
                      onTap: () {
                        printInfo("Section action clicked: ${section.name}");
                        openTaskPage(
                          section: section,
                          projectData: widget.data,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                      color: AppUtils.getSectionColor(section.name),
                      borderRadius: BorderRadius.circular(30)),
                ),
              ],
            ),
          ),
        ),
      ],
      items: items,
    );
  }

  _buildBoardItem(TaskEntity item) {
    final ThemeData theme = Theme.of(context);
    return BoardItem(
      draggable: isConnected,
      onStartDragItem: (listIndex, itemIndex, state) {},
      onDropItem: (
        listIndex,
        itemIndex,
        oldListIndex,
        oldItemIndex,
        BoardItemState state,
      ) {
        var item = widget.data.sections[oldListIndex!].tasks[oldItemIndex!];
        widget.data.sections[oldListIndex].tasks.removeAt(oldItemIndex);
        widget.data.sections[listIndex!].tasks.insert(itemIndex!, item);
        final section = widget.data.sections[listIndex];
        final task = section.tasks[itemIndex];
        if (oldListIndex == listIndex && oldItemIndex == itemIndex) {
          return;
        } else if (oldListIndex == listIndex) {
          final items = section.tasks.mapWithIndex((index, item) {
            return ReorderTasksParams(id: item.id, childOrder: index);
          }).toList();

          context.read<TaskCubit>().reoderItems(items);
        } else {
          final params = MoveTaskParams(
            id: task.id,
            sectionId: section.section.id,
            projectId: task.projectId,
          );
          context.read<TaskCubit>().moveTask(params);
        }
      },
      onTapItem: (
        listIndex,
        itemIndex,
        BoardItemState state,
      ) async {
        final sectionData = widget.data.sections[listIndex!];
        final task = sectionData.tasks[itemIndex!];
        final section = sectionData.section;

        printInfo(
          "Task: ${task.content} Project: ${widget.data.project.id} Section: ${section.name}",
        );
        openTaskPage(
          task: task,
          section: section,
          projectData: widget.data,
        );
      },
      item: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Material(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: TaskItemWidget(
                item: item,
                onActionClicked: () {
                  context.read<TaskCubit>().closeTask(item.id);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openTaskPage({
    TaskEntity? task,
    required ProjectData projectData,
    required SectionEntity section,
  }) {
    Navigator.push(
        context,
        TaskPage.route(
          task: task,
          projectData: projectData,
          section: section,
        )).then((needToReferesh) {
      if (needToReferesh == true) {
        context.read<TaskCubit>().getAllTasks();
      }
    });
  }

  void updateTask({
    required TaskEntity task,
    required ProjectEntity project,
    required SectionEntity section,
  }) {
    printInfo(project.id);
    final data = UpdateTaskParams(id: task.id);
    context.read<TaskCubit>().updateTask(data);
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  final TaskEntity task;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Card(
        color: theme.cardColor,
        elevation: 0,
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.content.toCapital,
                        style: theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        task.isCompleted
                            ? Icons.check_circle_outline_outlined
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: task.isCompleted ? Colors.green : null,
                      ),
                      onTap: () {
                        printInfo("Task action clicked: ${task.content}");
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                task.description.isNotEmpty
                    ? Text(
                        task.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      )
                    : const SizedBox(),
                SizedBox(
                  height: task.description.isNotEmpty ? 8.0 : 0,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppUtils.getPriorityColor(task.priority)
                            .withAlpha(50),
                      ),
                      child: Text(
                        AppUtils.getPriorityName(task.priority).toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: AppUtils.getPriorityColor(task.priority)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Spacer(),
                    task.commentCount > 0
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              CupertinoIcons.chat_bubble_2,
                              size: 20,
                            ),
                          )
                        : Container(),
                    task.commentCount > 0
                        ? Text(
                            task.commentCount.toString(),
                            style: theme.textTheme.bodyMedium,
                          )
                        : Container(),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  task.createdAt.formatDate(),
                ),
              ],
            )),
      ),
    );
  }
}
