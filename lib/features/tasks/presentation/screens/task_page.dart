import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/cubits/comment/comment_cubit.dart';
import 'package:itodo/common/cubits/project/project_cubit.dart';
import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/app_utils.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/common/utils/show_toast.dart';
import 'package:itodo/common/widgets/loading_indicator.dart';
import 'package:itodo/const/constants.dart';
import 'package:itodo/features/comments/domain/entity/comment_entity.dart';
import 'package:itodo/features/comments/domain/usecase/add_comment.dart';
import 'package:itodo/features/projects/domain/entity/project_entity.dart';
import 'package:itodo/features/sections/domain/entity/section_entity.dart';
import 'package:itodo/features/sections/presentation/cubit/section_cubit.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:itodo/features/tasks/domain/usecase/add_task.dart';
import 'package:itodo/features/tasks/domain/usecase/update_task.dart';

import '../../../../common/cubits/task/task_cubit.dart';
import '../../../../common/cubits/theme/theme_cubit.dart';
import '../../../../common/models/project_data.dart';
import '../../../../common/utils/color_chip.dart';
import '../../../../l10n/l10n.dart';
import '../../../../common/widgets/confirmation_dialog.dart';
import '../../domain/usecase/move_task.dart';

class TaskPage extends StatefulWidget {
  static route({
    SectionEntity? section,
    ProjectData? projectData,
    TaskEntity? task,
  }) =>
      MaterialPageRoute<bool>(
          builder: (context) => TaskPage(
                section: section,
                projectData: projectData,
                task: task,
              ));

  final SectionEntity? section;
  final ProjectData? projectData;
  final TaskEntity? task;

  const TaskPage({
    super.key,
    required this.section,
    required this.projectData,
    this.task,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  int _priority = 4;
  late ProjectEntity _project;
  late SectionEntity _section;
  List<SectionEntity> _sections = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      printInfo(widget.task!.content);
      _titleController.text = widget.task?.content ?? '';
      _descriptionController.text = widget.task?.description ?? '';
      _priority = widget.task!.priority;
      if (widget.projectData == null) {
        context.read<ProjectCubit>().getProject(widget.task!.projectId);
      }
      context.read<CommentCubit>().getAllComments(widget.task!.id);
    }
    if (widget.projectData != null) {
      _project = widget.projectData!.project;
      _projectController.text = widget.projectData!.project.name;
      _sections = widget.projectData!.sections.map((sectionData) {
        return sectionData.section;
      }).toList();
    }
    if (widget.section != null) {
      _section = widget.section!;
    }
    setState(() {});
  }

  bool isUpdated = false;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context, isUpdated);
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.task == null ? l10n.create_task : l10n.update_task,
          ),
          actions: [
            widget.task != null
                ? IconButton(
                    onPressed: () async {
                      showDeleteTask(widget.task!);
                    },
                    icon: const Icon(
                      CupertinoIcons.delete,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ProjectCubit, ProjectState>(
              listener: (context, state) {
                if (state is ProjectLoading) {
                  isLoading = true;
                }
                if (state is ProjectLoaded) {
                  if (state.items.isNotEmpty) {
                    _project = state.items[0];
                    context.read<SectionCubit>().getAllByProjectId(_project.id);
                  } else {
                    showToast('Project not found');
                  }
                }
                if (state is ProjectError) {
                  showToast(state.message);
                }
              },
            ),
            BlocListener<SectionCubit, SectionState>(
              listener: (context, state) {
                if (state is SectionLoading) {
                  isLoading = true;
                }
                if (state is SectionLoaded) {
                  if (state.items.isNotEmpty) {
                    _section = state.items[0];
                  } else {
                    showToast('Section not found');
                  }
                }
                if (state is SectionError) {
                  showToast(state.message);
                }
              },
            ),
            BlocListener<TaskCubit, TaskState>(
              listener: (context, state) {
                printInfo(state);
                if (state is TaskLoading) {
                  setState(() {
                    printInfo("Loading");
                    isLoading = true;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
                if (state is TaskShuffeled) {
                  isUpdated = true;
                }
                if (state is TaskSuccess || state is TaskSuccessMessage) {
                  showToast("Success");
                  isUpdated = true;
                  Navigator.pop(context, true);
                }
                if (state is TaskError) {
                  showToast(state.message);
                }
              },
            )
          ],
          child: taskView(l10n, context),
        ),
      ),
    );
  }

  Widget taskView(AppLocalizations l10n, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.project),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _projectController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.section),
                          const SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField<SectionEntity>(
                            value: _section,
                            iconSize: 16,
                            onChanged: (value) {
                              if (widget.task != null) {
                                final params = MoveTaskParams(
                                  id: widget.task!.id,
                                  sectionId: value!.id,
                                  projectId: widget.task!.projectId,
                                );
                                context.read<TaskCubit>().moveTask(params);
                              }
                              setState(() {
                                _section = value!;
                              });
                            },
                            items: _sections.map((section) {
                              return DropdownMenuItem(
                                value: section,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: AppUtils.getSectionColor(
                                          section.name),
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(section.name),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.title),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _titleController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.priority),
                          const SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField<int>(
                            value: _priority,
                            iconSize: 16,
                            onChanged: (value) {
                              setState(() {
                                _priority = value!;
                              });
                            },
                            items: [1, 2, 3, 4]
                                .map((priority) => DropdownMenuItem(
                                      value: priority,
                                      child: Row(
                                        children: [
                                          Icon(Icons.flag,
                                              color: AppUtils.getPriorityColor(
                                                  priority)),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Text(AppUtils.getPriorityName(
                                              priority)),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.description),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          saveUpdateTask();
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          widget.task == null
                              ? l10n.create_task.toUpperCase()
                              : l10n.update_task.toUpperCase(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    widget.task != null
                        ? Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    widget.task?.isCompleted != true
                                        ? Colors.green
                                        : Colors.amber,
                              ),
                              onPressed: () {
                                if (widget.task?.isCompleted == true) {
                                  reopenTask(widget.task!.id);
                                } else {
                                  closeTask(widget.task!.id);
                                }
                              },
                              child: Text(
                                l10n.mark_as_complete.toUpperCase(),
                              ),
                            ),
                          )
                        : Expanded(flex: 1, child: Container()),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                commentView()
              ],
            ),
          ),
        ),
        isLoading ? const LoadingIndicator() : Container()
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void saveUpdateTask() {
    if (widget.task != null) {
      UpdateTaskParams item = UpdateTaskParams(
        id: widget.task!.id,
        content: _titleController.text,
        description: _descriptionController.text,
        priority: _priority,
      );
      context.read<TaskCubit>().updateTask(item);
    } else {
      AddTaskParams item = AddTaskParams(
        content: _titleController.text,
        description: _descriptionController.text,
        priority: _priority,
        projectId: _project.id,
        sectionId: _section.id,
      );
      context.read<TaskCubit>().addTask(item);
    }
  }

  showDeleteTask(TaskEntity task) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.confirmation,
          message: l10n.delete_task_confirmation,
          icon: CupertinoIcons.exclamationmark,
          onConfirm: () {
            context.read<TaskCubit>().deleteTask(task.id);
          },
        );
      },
    );
  }

  void closeTask(String id) {
    context.read<TaskCubit>().closeTask(id);
  }

  void reopenTask(String id) {
    context.read<TaskCubit>().reopenTask(id);
  }

  List<CommentEntity> comments = [];
  bool isCommentLoading = false;
  Widget commentView() {
    final ThemeData theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentLoading) {
          printInfo("Comment loading");
          setState(() {
            isCommentLoading = true;
          });
        } else {
          setState(() {
            isCommentLoading = false;
          });
        }
        if (state is CommentLoaded) {
          printInfo("Comment Loaded: ${state.items.length}");
          comments = state.items;
          comments.sort((a, b) =>
              DateTime.parse(b.postedAt).compareTo(DateTime.parse(a.postedAt)));
          setState(() {});
        }
        if (state is CommentSuccessMessage || state is CommentSuccess) {
          context.read<CommentCubit>().getAllComments(widget.task!.id);
          isUpdated = true;
        }
        if (state is CommentError) {
          printInfo("Comment Error: ${state.message}");
        }
      },
      builder: (context, state) {
        final ThemeData theme = Theme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.comments),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(
                    CupertinoIcons.person_fill,
                    color: theme.cardColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: l10n.type_your_comment_here,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        AddCommentParams params = AddCommentParams(
                          content: _commentController.text,
                          taskId: widget.task!.id,
                          projectId: _project.id,
                        );
                        context.read<CommentCubit>().addComment(params);
                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            isCommentLoading
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 16,
            ),
            for (int index = 0; index < comments.length; index++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(0),
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(0),
                        ),
                        color: context.read<ThemeCubit>().currentTheme ==
                                ThemeMode.dark
                            ? darkCardColor
                            : grayColor200,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: getColorByIndex(index)),
                        child: const Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          color: context.read<ThemeCubit>().currentTheme ==
                                  ThemeMode.dark
                              ? darkCardColor
                              : grayColor200,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, right: 8, bottom: 8),
                              child: Text(
                                "${l10n.posted_at}: ${comments[index].postedAt.toDate().toFormatedDate()}",
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: theme.scaffoldBackgroundColor),
                                      child: Text(comments[index].content)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
