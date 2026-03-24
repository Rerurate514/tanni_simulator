import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CheckCategoryRequirement extends HookConsumerWidget {
  const CheckCategoryRequirement({super.key, required this.total, required this.target, required this.chip});

  final int total;
  final int target;
  final AppChip chip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            l10n.tanni_count(total, target),
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        AppGap.s(),
        Expanded(
          flex: 3,
          child: LinearPercentIndicator(
            animation: true,
            animateFromLastPercent: true,
            lineHeight: 24.0,
            percent: min(total / target, 1),
            barRadius: const Radius.circular(12),
            progressColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            padding: EdgeInsets.zero,
          ),
        ),
        AppGap.s(),
        Expanded(
          flex: 1,
          child: chip,
        )
      ],
    );
  }
}
