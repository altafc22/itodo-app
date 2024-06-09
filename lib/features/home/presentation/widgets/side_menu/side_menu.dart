import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/app_utils.dart';
import 'package:itodo/const/constants.dart';
import 'package:itodo/features/tasks/presentation/screens/completed_tasks_page.dart';

import '../../../../../common/cubits/locale/locale_cubit.dart';
import '../../../../../common/cubits/task/task_cubit.dart';
import '../../../../../common/cubits/theme/theme_cubit.dart';
import '../../../../../common/utils/color_chip.dart';
import '../../../../../common/utils/responsive.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../projects/domain/entity/project_entity.dart';
import 'side_menu_item.dart';

// ignore: must_be_immutable
class SideMenuWidget extends StatefulWidget {
  List<ProjectEntity> items;
  int selectedIndex;

  SideMenuWidget(
      {super.key,
      required this.items,
      required this.onProjectClicked,
      this.selectedIndex = 0});

  Function(ProjectEntity item, int index) onProjectClicked;
  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Assets.images.icon.image(height: 32, width: 32),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  l10n.appName,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(l10n.myProjects.toUpperCase()),
                  const SizedBox(
                    height: 16,
                  ),
                  for (int i = 0; i < widget.items.length; i++)
                    ProjectItemWidget(
                        icon: getColorChip(widget.items[i].color),
                        text: widget.items[i].name,
                        onTap: () {
                          widget.onProjectClicked(widget.items[i], i);
                          if (!isDesktop) {
                            _closeDrawer(context);
                          }
                        },
                        isSelected: widget.selectedIndex == i),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                  ProjectItemWidget(
                      icon: getColorChip('green'),
                      text: l10n.completed_tasks,
                      onTap: () {
                        if (!isDesktop) {
                          _closeDrawer(context);
                        }

                        Navigator.push(context, CompletedTasksPage.route())
                            .then((needToReferesh) {
                          if (needToReferesh == true) {
                            context.read<TaskCubit>().getAllTasks();
                          }
                        });
                      },
                      isSelected: false),
                  const Divider(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  AppUtils.showLanguageBottomSheet(context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.language,
                      style: theme.textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(
                      _getLanguageName(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    l10n.darkMode,
                    style: theme.textTheme.titleSmall,
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    value: context.read<ThemeCubit>().currentTheme ==
                        ThemeMode.dark,
                    onChanged: (bool value) {
                      if (!isDesktop) {
                        _closeDrawer(context);
                      }
                      context.read<ThemeCubit>().toggleTheme();
                    },
                    activeColor: primaryColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName() {
    final lagunage = context.read<LocaleCubit>().currentLocale;
    return lagunage.fullName();
  }

  void _closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }
}
