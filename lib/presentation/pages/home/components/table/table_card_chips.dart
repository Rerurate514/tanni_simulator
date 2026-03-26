import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/core/utils/app_color_scheme.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/credit_limited_rule.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group_state.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class TableCardChips extends HookConsumerWidget {
  const TableCardChips({
    required this.course,
    required this.eg,
    required this.clrs,
    super.key,
  });

  final CourseModel course;
  final ExclusiveGroupState? eg;
  final List<CreditLimitRuleModel> clrs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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
              l10n.tanni(course.credits),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        if (course.isRequired)
          AppChip(
            label: l10n.category_required,
            color: theme.colorScheme.error,
            fontSize: 9,
          ),
        if (eg != null)
          AppChip(
            label: l10n.exclusive_credits_with_group_name(
              eg!.group.name,
            ),
            color: theme.colorScheme.exclusive,
            fontSize: 9,
          ),

        if (clrs.isNotEmpty)
          for (final clr in clrs)
            AppChip(
              label: l10n.limit_credits_with_group_name(
                clr.name,
                clr.maxCreditsAllowed,
              ),
              color: theme.colorScheme.limit,
              fontSize: 9,
            ),
      ],
    );
  }
}
