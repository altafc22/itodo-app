import 'package:flutter/material.dart';
import 'package:itodo/l10n/l10n.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../const/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PopScope(
        canPop: false,
        child: Center(
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1, color: grayColor500)),
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  LoadingAnimationWidget.twoRotatingArc(
                    color: primaryColor,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(l10n.please_wait),
                  const Spacer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
