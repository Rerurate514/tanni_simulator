import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/credit/is_credit_completed_provider.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/application/state/exclusive_groups_notifier.dart';
import 'package:tanni_simulator/core/utils/app_color_scheme.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group_state.dart';
import 'package:tanni_simulator/domain/service/exclusive_groups_service.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumTableCard extends HookConsumerWidget {
  const CurriculumTableCard({required this.courseModel, super.key});

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final isCreditsCompleted = ref.watch(
      isCreditCompletedProvider(courseModel),
    );

    final egService = ref.watch(exclusiveGroupServiceProvider);
    final egs = ref.watch(exclusiveGroupsProvider);
    final eg = egService.findGroupByCourse(egs, courseModel);

    final activeColor = isCreditsCompleted
        ? theme.colorScheme.primary
        : theme.dividerColor.withAlpha(40);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 300,
      ),
      child: Card(
        elevation: isCreditsCompleted ? 0 : 2,
        color: isCreditsCompleted
            ? theme.colorScheme.primaryContainer.withAlpha(40)
            : theme.cardColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: activeColor,
            width: isCreditsCompleted ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () =>
              ref.read(courseListProvider.notifier).toggle(courseModel),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      courseModel.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: isCreditsCompleted
                            ? theme.colorScheme.onSurface
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const AppGap.xs(),

                    _buildChips(l10n, theme, eg),
                  ],
                ),
              ),
              if (isCreditsCompleted)
                _buildCompletedIcon(theme)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChips(
    AppLocalizations l10n,
    ThemeData theme,
    ExclusiveGroupState? eg,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_motion_outlined,
              size: 14,
              color: theme.hintColor,
            ),
            const AppGap.xs(),
            Text(
              l10n.tanni(courseModel.credits),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        if (courseModel.isRequired)
          AppChip(
            label: l10n.category_required,
            color: theme.colorScheme.error,
            fontSize: 9,
          ),
        if (eg != null)
          AppChip(
            label: l10n.exclusive_credits_with_group_name(
              eg.group.name,
            ),
            color: theme.colorScheme.exclusive,
            fontSize: 9,
          ),
      ],
    );
  }

  Widget _buildCompletedIcon(ThemeData theme) {
    return Positioned(
      top: 4,
      right: 4,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Icon(
            Icons.check_circle,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
