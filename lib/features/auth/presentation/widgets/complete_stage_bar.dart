import 'package:flutter/material.dart';

class CompleteStageBar extends StatelessWidget {
  final int currentStep;
  static const int totalSteps = 4;

  const CompleteStageBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 8.0,
          backgroundColor: Theme.of(context).colorScheme.secondaryFixedDim,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
