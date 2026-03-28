import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/requirement/missing_courses_list_provider.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/bottom/missing_courses.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class MissingCoursesBottomSheet extends HookConsumerWidget {
  const MissingCoursesBottomSheet({required this.curriculum, super.key});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final selectedRequirement = ref.watch(selectedRequirementProvider);
    if (selectedRequirement == null) return const SizedBox.shrink();

    final missingCourses = ref.watch(
      missingCoursesListProvider(selectedRequirement, curriculum),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const AppGap.m(),

          Text(
            l10n.section_requirements,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const AppGap.m(),

          MissingCourses(missingCourses: missingCourses),

          const AppGap.l(),

          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.btn_close),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
