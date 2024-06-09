import 'package:flutter/material.dart';

import '../../../../../const/constants.dart';

class ProjectItemWidget extends StatelessWidget {
  const ProjectItemWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  final Widget icon;
  final String text;
  final Function onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () {
            onTap();
          },
          title: Row(
            children: [
              icon,
              //getColorChip(item.color),
              const SizedBox(
                width: 16,
              ),
              Text(
                text,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          tileColor: isSelected ? primaryColor.withAlpha(100) : null,
        ),
      ),
    );
  }
}
