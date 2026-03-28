import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/core/utils/app_color_scheme.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class MissingCourses extends HookConsumerWidget {
  const MissingCourses({
    required this.missingCourses, super.key
  });

  final List<CourseModel> missingCourses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (missingCourses.isEmpty) {
      return AppChip(
        label: l10n.promotion_earned_label,
        color: theme.colorScheme.success,
        fontSize: 11,
        borderRadius: 8,
        backgroundOpacity: 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 4),
            Text(
              l10n.promotion_not_earned_label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const AppGap.s(),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: missingCourses.map((course) {
            return AppChip(
              label: '${course.name} (${course.credits})',
              color: theme.colorScheme.error,
              fontSize: 11,
              borderRadius: 8,
              backgroundOpacity: 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            );
          }).toList(),
        ),
      ],
    );
  }
}
