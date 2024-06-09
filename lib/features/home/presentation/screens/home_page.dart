import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/cubits/task/task_cubit.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/features/projects/domain/entity/project_entity.dart';
import 'package:itodo/features/sections/domain/entity/section_entity.dart';
import 'package:itodo/features/sections/presentation/cubit/section_cubit.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';

import '../../../../common/cubits/project/project_cubit.dart';

import '../../../../common/models/project_data.dart';
import '../../../../common/models/section_data.dart';
import '../../../../common/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/tasks_board_grid.dart';
import '../widgets/side_menu/side_menu.dart';
import '../widgets/tasks_board_list.dart';

class HomePage extends StatefulWidget {
  static route({
    required List<SectionEntity> sections,
    required List<ProjectEntity> projects,
    required List<TaskEntity> tasks,
  }) =>
      MaterialPageRoute<bool>(
          builder: (context) => HomePage(
                sections: sections,
                projects: projects,
                tasks: tasks,
              ));

  const HomePage({
    super.key,
    required this.projects,
    required this.sections,
    required this.tasks,
  });

  final List<ProjectEntity> projects;
  final List<SectionEntity> sections;
  final List<TaskEntity> tasks;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProjectEntity> _projects = [];
  List<SectionEntity> _sections = [];
  List<TaskEntity> _tasks = [];

  List<ProjectData> organizedItems = [];

  ProjectEntity? selectedProject;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _projects = widget.projects;
    _sections = widget.sections;
    _tasks = widget.tasks;

    if (_projects.isNotEmpty) {
      selectedProject = _projects[selectedIndex];
    }
    organizedItems = getOrganizedData();
    setState(() {});
    //context.read<ProjectCubit>().getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: !isDesktop
          ? AppBar(
              title: selectedProject != null ? Text(l10n.appName) : null,
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<TaskCubit>().getAllTasks();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            )
          : null,
      drawer: !isDesktop ? SizedBox(width: 350, child: _sideMenu()) : null,
      endDrawer: !isDesktop ? SizedBox(width: 350, child: _sideMenu()) : null,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProjectCubit, ProjectState>(
              listener: (context, state) {
                if (state is ProjectLoaded) {
                  printInfo("Project ${state.items.length}");
                  _projects = state.items;
                  if (_projects.isNotEmpty) {
                    selectedProject = _projects[0];
                  }
                  context
                      .read<SectionCubit>()
                      .getAllSections(); //fething all sections
                }
              },
            ),
            BlocListener<SectionCubit, SectionState>(
              listener: (context, state) {
                if (state is SectionLoaded) {
                  printInfo("Sections ${state.items.length}");
                  _sections = state.items;
                  context.read<TaskCubit>().getAllTasks(); //fething all tasks
                }
              },
            ),
            BlocListener<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state is TaskSuccessMessage) {
                  context.read<TaskCubit>().getAllTasks();
                }
                if (state is TaskLoaded) {
                  printInfo("Tasks ${state.items.length}");
                  _tasks = state.items;
                  setState(() {
                    organizedItems = getOrganizedData();
                  });
                }
              },
            ),
          ],
          child: Row(
            children: [
              if (isDesktop)
                Expanded(
                  flex: 2,
                  child: SizedBox(child: _sideMenu()),
                ),
              Expanded(flex: 7, child: getBoardView()),
            ],
          ),
        ),
      ),
    );
  }

  int selectedIndex = 0;
  Widget _sideMenu() {
    return SideMenuWidget(
      items: _projects,
      selectedIndex: selectedIndex,
      onProjectClicked: (item, index) {
        printInfo("Project clicked: ${item.name}");
        setState(() {
          selectedIndex = index;
          selectedProject = _projects[index];
          organizedItems = getOrganizedData();
        });
      },
    );
  }

  Widget getBoardView() {
    final isDesktop = Responsive.isDesktop(context);
    if (selectedProject != null) {
      final data = getProjectData(selectedProject!.id);
      if (data != null) {
        return selectedProject != null
            ? isDesktop
                ? TaskBoardGrid(data: data)
                : TaskBoardList(
                    data: data,
                  )
            : Container();
      }
      return Container();
    }
    return Container();
  }

  List<ProjectData> getOrganizedData() {
    Map<String, List<TaskEntity>> tasksBySection = {};
    for (var task in _tasks) {
      if (tasksBySection[task.sectionId] == null) {
        tasksBySection[task.sectionId] = [];
      }
      tasksBySection[task.sectionId]!.add(task);
    }

    Map<String, List<SectionData>> sectionsByProject = {};
    for (var section in _sections) {
      if (sectionsByProject[section.projectId] == null) {
        sectionsByProject[section.projectId] = [];
      }
      sectionsByProject[section.projectId]!.add(
        SectionData(
          section: section,
          tasks: tasksBySection[section.id] ?? [],
        ),
      );
    }

    List<ProjectData> projectDataList = [];
    for (var project in _projects) {
      projectDataList.add(
        ProjectData(
          project: project,
          sections: sectionsByProject[project.id] ?? [],
        ),
      );
    }

    return projectDataList;
  }

  ProjectData? getProjectData(String projectId) {
    final data = organizedItems.firstWhereOrNull(
      (item) => item.project.id == projectId,
    );
    return data;
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.pop(_scaffoldKey.currentContext!);
  }
}
