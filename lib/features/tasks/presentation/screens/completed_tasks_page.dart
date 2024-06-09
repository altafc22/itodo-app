import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/show_toast.dart';
import 'package:itodo/common/widgets/loading_indicator.dart';
import 'package:itodo/features/tasks/domain/entitiy/completed_tasks_entity.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/presentation/screens/task_page.dart';
import 'package:itodo/l10n/l10n.dart';

import '../../../../common/cubits/task/task_cubit.dart';
import '../../../../common/cubits/theme/theme_cubit.dart';
import '../../../../common/utils/log_utils.dart';
import '../../../../common/widgets/confirmation_dialog.dart';
import '../../../../common/widgets/no_items.dart';
import '../../../../const/constants.dart';

class CompletedTasksPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute<bool>(builder: (context) => const CompletedTasksPage());

  const CompletedTasksPage({
    super.key,
  });

  @override
  State<CompletedTasksPage> createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  TabController? _controller;
  CompletedTasksEntity? data;
  List<CompletedItemEntity> list = [];

  @override
  void initState() {
    super.initState();
    _getAllTasks();
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.completed_tasks),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskLoading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
          if (state is TaskSuccess || state is TaskSuccessMessage) {
            //Navigator.pop(context, true);
            _getAllTasks();
          }
          if (state is CompletedTaskLoaded) {
            data = state.data;
            list = state.data.items;
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
                child: _getTaskList(list),
              ),
              isLoading ? const LoadingIndicator() : Container()
            ],
          );
        },
      ),
    );
  }

  _getAllTasks() {
    context.read<TaskCubit>().getCompletedTasks();
  }

  _getTaskList(List<CompletedItemEntity> tasks) {
    final l10n = AppLocalizations.of(context)!;
    return tasks.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              for (int index = 0; index < tasks.length; index += 1)
                Padding(
                  key: ValueKey(tasks[index]),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      tileColor: context.read<ThemeCubit>().currentTheme ==
                              ThemeMode.dark
                          ? darkCardColor
                          : grayColor200,
                      key: Key(data!.items[index].id!),
                      leading: const Icon(CupertinoIcons.checkmark_circle),
                      title: Text(tasks[index].content),
                      trailing: IconButton(
                          onPressed: () {
                            showDeleteTask(tasks[index].taskId!);
                          },
                          icon: const Icon(CupertinoIcons.delete)),
                      subtitle: Text(
                        "${l10n.completed_at}: ${data!.items[index].completedAt!.toDate().toFormatedDate()}",
                      ),
                    ),
                  ),
                ),
            ],
          )
        : Center(
            child: NoItemsWidget(
            label: l10n.no_items_found,
            child: Container(),
          ));
  }

  void openTaskPage({TaskEntity? task}) {
    printInfo("Task $task");

    Navigator.push(context, TaskPage.route(task: task)).then((needToReferesh) {
      if (needToReferesh == true) {
        context.read<TaskCubit>().getAllTasks();
      }
    });
  }

  void closeTask(String id) {
    context.read<TaskCubit>().closeTask(id);
  }

  showDeleteTask(String id) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.confirmation,
          message: l10n.delete_task_confirmation,
          icon: CupertinoIcons.exclamationmark,
          onConfirm: () {
            context.read<TaskCubit>().deleteTask(id);
          },
        );
      },
    );
  }
}
