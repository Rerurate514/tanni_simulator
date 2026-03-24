import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class MissingCourses extends HookConsumerWidget {
  const MissingCourses({super.key, required this.missingCourses});

  final List<CourseModel> missingCourses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        if (missingCourses.isNotEmpty) Text(
          l10n.promotion_not_earned_label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppGap.xs(),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: missingCourses.map((course) => AppChip(
            label: course.name,
            color: theme.colorScheme.error,
            fontSize: 12,
            borderRadius: 6,
            backgroundOpacity: 0.15,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          )).toList(),
        )
      ],
    );
  }
}
