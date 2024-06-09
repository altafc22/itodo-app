import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/cubits/locale/locale_cubit.dart';
import 'package:itodo/common/extensions/app_extension.dart';

import '../../features/tasks/domain/entitiy/task_entity.dart';

import '../utils/app_utils.dart';
import '../utils/log_utils.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskEntity item;

  final Function onActionClicked;

  const TaskItemWidget({
    super.key,
    required this.item,
    required this.onActionClicked,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppUtils.getPriorityColor(item.priority).withAlpha(50),
                ),
                child: Text(
                  AppUtils.getPriorityName(item.priority).toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: AppUtils.getPriorityColor(item.priority)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                item.content.toCapital,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(
                width: 16,
              ),
              const SizedBox(
                height: 8.0,
              ),
              item.description.isNotEmpty
                  ? Text(
                      item.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    )
                  : const SizedBox(),
              SizedBox(
                height: item.description.isNotEmpty ? 8.0 : 0,
              ),
              Row(
                children: [
                  Text(
                    item.createdAt.formatDate(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  item.commentCount > 0
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            CupertinoIcons.chat_bubble_2,
                            size: 18,
                          ),
                        )
                      : Container(),
                  item.commentCount > 0
                      ? Text(
                          item.commentCount.toString(),
                          style: theme.textTheme.bodyMedium,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: context.read<LocaleCubit>().currentLocale.languageCode != 'ar'
              ? 0
              : null,
          left: context.read<LocaleCubit>().currentLocale.languageCode == 'ar'
              ? 0
              : null,
          child: IconButton(
            icon: Icon(
              item.isCompleted
                  ? CupertinoIcons.checkmark_alt_circle
                  : CupertinoIcons.circle,
              size: 20,
            ),
            onPressed: () {
              printInfo("Task action clicked: ${item.content}");
              onActionClicked();
            },
          ),
        ),
      ],
    );
  }
}
