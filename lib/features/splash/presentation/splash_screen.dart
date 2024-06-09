import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/cubits/project/project_cubit.dart';
import 'package:itodo/common/cubits/task/task_cubit.dart';
import 'package:itodo/const/constants.dart';
import 'package:itodo/features/home/presentation/screens/home_page.dart';
import 'package:itodo/features/sections/presentation/cubit/section_cubit.dart';
import 'package:itodo/features/tasks/domain/entitiy/task_entity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../common/widgets/alert_dialog.dart';
import '../../../gen/assets.gen.dart';
import '../../../l10n/l10n.dart';
import '../../projects/domain/entity/project_entity.dart';
import '../../sections/domain/entity/section_entity.dart';

class SplashScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute<bool>(builder: (context) => const SplashScreen());

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';

  List<ProjectEntity> projects = [];
  List<SectionEntity> sections = [];
  List<TaskEntity> tasks = [];

  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ProjectCubit, ProjectState>(
          listener: (context, state) {
            if (state is ProjectLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is ProjectLoaded) {
              projects = state.items;
              context.read<SectionCubit>().getAllSections();
            }
            if (state is ProjectError) {
              setState(() {
                isLoading = false;
                errorMessage = state.message;
              });
            }
          },
        ),
        BlocListener<SectionCubit, SectionState>(
          listener: (context, state) {
            if (state is SectionLoading) {
              setState(() {
                isLoading = true;
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }
            if (state is SectionLoaded) {
              setState(() {
                sections = state.items;
              });
              context.read<TaskCubit>().getAllTasks();
            }
            if (state is SectionError) {
              setState(() {
                errorMessage = state.message;
              });
            }
          },
        ),
        BlocListener<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is TaskLoaded) {
              tasks = state.items;
              Navigator.pushReplacement(
                context,
                HomePage.route(
                  projects: projects,
                  sections: sections,
                  tasks: tasks,
                ),
              );
            }
            if (state is TaskError) {
              isLoading = false;
              errorMessage = state.message;
            }
          },
        ),
      ],
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Assets.images.icon.image(
              height: 96,
              width: 96,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              l10n.appName,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                : Container(),
            errorMessage.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {},
                    child: Text(l10n.retry),
                  )
                : Container(),
            isLoading
                ? Container(
                    child: LoadingAnimationWidget.twoRotatingArc(
                      color: primaryColor,
                      size: 50,
                    ),
                  )
                : Container(),
            const Spacer()
          ],
        ),
      ),
    );
  }

  showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: "Alert",
          message: message,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
