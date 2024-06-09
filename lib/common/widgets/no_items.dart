import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

// ignore: must_be_immutable
class NoItemsWidget extends StatelessWidget {
  String label;
  Widget? child;
  NoItemsWidget({super.key, required this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Assets.images.noItems.image(height: 100),
        const SizedBox(
          height: 8,
        ),
        Text(label),
        const SizedBox(
          height: 16,
        ),
        child ?? Container()
      ],
    );
  }
}
