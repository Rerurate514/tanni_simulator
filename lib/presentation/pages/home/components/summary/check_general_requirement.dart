import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/domain/constants/app_color_scheme.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/check_category_requirement.dart';
import 'package:tanni_simulator/presentation/pages/home/providers/category_credits_progress_provider.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';

class CheckGeneralRequirement extends HookConsumerWidget {
  const CheckGeneralRequirement({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    const notRequiredEarnCredit = 0;

    final progress = ref.watch(categoryCreditsEarnedProvider(CategoryType.general));
    if(progress == null || progress.$2 == notRequiredEarnCredit) return SizedBox.shrink();

    final (total, target) = progress;
    final isGeneralRequirementMet = ref.watch(isGeneralRequirementMetProvider);

    return CheckCategoryRequirement(
      total: total, 
      target: target, 
      chip: AppChip(
        label: isGeneralRequirementMet
        ? l10n.promotion_earned_general_credit
        : l10n.promotion_not_earned_general_credit,
        color: isGeneralRequirementMet
        ? theme.colorScheme.success
        : theme.colorScheme.error, 
      )
    );
  }
}
