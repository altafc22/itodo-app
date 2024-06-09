import 'package:dynamic_tabbar/dynamic_tabbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/widgets/loading_indicator.dart';
import 'package:itodo/const/constants.dart';
import 'package:itodo/features/sections/domain/entity/section_entity.dart';

import '../../../../common/cubits/task/task_cubit.dart';
import '../../../../common/models/project_data.dart';
import '../../../../common/models/section_data.dart';
import '../../../../common/utils/log_utils.dart';
import '../../../../common/utils/show_toast.dart';
import '../../../../common/widgets/no_items.dart';
import '../../../../common/widgets/task_item_widget.dart';
import '../../../../x_bloc_pack/blocs.dart';
import '../../../tasks/domain/entitiy/task_entity.dart';
import '../../../tasks/domain/usecase/reorder_task.dart';
import '../../../tasks/presentation/screens/task_page.dart';

class TaskBoardList extends StatefulWidget {
  const TaskBoardList({super.key, required this.data});
  final ProjectData data;

  @override
  State<TaskBoardList> createState() => _TaskBoardListState();
}

class _TaskBoardListState extends State<TaskBoardList> {
  TabController? _controller;
  List<SectionData> lists = [];
  int selectedIndex = 0;
  late SectionData selectedSection;
  @override
  void initState() {
    if (widget.data.sections.isNotEmpty) {
      for (int i = 0; i < widget.data.sections.length; i++) {
        final sectionData = widget.data.sections;
        lists.add(sectionData[i]);
      }
      selectedIndex = 0;
      selectedSection = widget.data.sections[selectedIndex];
    }
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          widget.data.project.name,
                          style: theme.textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: getColorByName('green').withAlpha(100),
                                borderRadius: BorderRadius.circular(6)),
                            child: const Icon(Icons.add, size: 20),
                          ),
                          onTap: () {
                            final projectData = widget.data;
                            printInfo(
                                "Project: ${projectData.project.name} Section: ${selectedSection.section.name}");
                            openTaskPage(
                              project: projectData,
                              section: selectedSection.section,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: DynamicTabBarWidget(
                      splashBorderRadius: BorderRadius.circular(8),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      showBackIcon: false,
                      showNextIcon: false,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor,
                      ),
                      labelColor: Colors.white,
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      dynamicTabs: widget.data.sections.map(
                        (sectionData) {
                          final section = sectionData.section;
                          final tasks = sectionData.tasks;
                          return TabData(
                            index: widget.data.sections.indexOf(sectionData),
                            title: Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(section.name),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: context
                                                  .read<ThemeCubit>()
                                                  .currentTheme !=
                                              ThemeMode.dark
                                          ? Colors.black26
                                          : Colors.white24,
                                    ),
                                    child: Text(
                                      tasks.length.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            content: _getTaskList(tasks),
                          );
                        },
                      ).toList(),
                      onTabControllerUpdated: (controller) {},
                      onTabChanged: (index) {
                        if (index != null) {
                          selectedIndex = index;
                          selectedSection = widget.data.sections[index];
                          printInfo(selectedSection.section.name);
                          setState(() {});
                        }
                      },
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

  _getTaskList(List<TaskEntity> tasks) {
    final ThemeData theme = Theme.of(context);
    return tasks.isNotEmpty
        ? ReorderableListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, item);
                if (oldIndex != newIndex) {
                  final items =
                      selectedSection.tasks.mapWithIndex((index, item) {
                    return ReorderTasksParams(id: item.id, childOrder: index);
                  }).toList();
                  context.read<TaskCubit>().reoderItems(items);
                }
              });
            },
            children: [
              for (int index = 0; index < tasks.length; index += 1)
                Padding(
                  padding: const EdgeInsets.all(8),
                  key: ValueKey(tasks[index]),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tileColor: context.read<ThemeCubit>().currentTheme ==
                              ThemeMode.dark
                          ? darkCardColor
                          : grayColor200,
                      onTap: () {
                        openTaskPage(
                          task: tasks[index],
                          project: widget.data,
                          section: selectedSection.section,
                        );
                      },
                      key: Key(tasks[index].id),
                      title: TaskItemWidget(
                        item: tasks[index],
                        onActionClicked: () {
                          context.read<TaskCubit>().closeTask(tasks[index].id);
                        },
                      ),
                    ),
                  ),
                ),
            ],
          )
        : NoItemsWidget(
            label: "You have no task listed.",
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Add",
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  void openTaskPage({
    TaskEntity? task,
    required ProjectData project,
    required SectionEntity section,
  }) {
    printInfo(
        "Project: ${project.project.name} Section: ${selectedSection.section.name}");

    Navigator.push(
        context,
        TaskPage.route(
          task: task,
          projectData: project,
          section: section,
        )).then((needToReferesh) {
      if (needToReferesh == true) {
        context.read<TaskCubit>().getAllTasks();
      }
    });
  }
}
