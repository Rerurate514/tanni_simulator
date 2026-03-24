import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.total,
    required this.target,
    this.height = 24.0,
    this.progressColor,
  });

  final int total;
  final int target;
  final double height;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAchieved = total >= target;
    
    final effectiveProgressColor = progressColor ?? 
        (isAchieved ? Colors.green : theme.colorScheme.error);

    return LinearPercentIndicator(
      animation: true,
      animateFromLastPercent: true,
      lineHeight: height,
      percent: target > 0 ? min(total / target, 1.0) : 0.0,
      barRadius: Radius.circular(height / 2),
      progressColor: effectiveProgressColor,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      padding: EdgeInsets.zero,
    );
  }
}
