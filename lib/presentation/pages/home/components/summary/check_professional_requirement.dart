import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/requirement/category_credits_progress_provider.dart';
import 'package:tanni_simulator/core/utils/app_color_scheme.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/check_category_requirement.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';

class CheckProfessionalRequirement extends HookConsumerWidget {
  const CheckProfessionalRequirement({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    const notRequiredEarnCredit = 0;

    final progress = ref.watch(
      effectiveCategoryCreditsEarnedProvider(CategoryType.professional),
    );
    if (progress == null || progress.$2 == notRequiredEarnCredit) {
      return const SizedBox.shrink();
    }

    final (total, target) = progress;
    final isProfessionalRequirementMet = ref.watch(
      isProfessionalRequirementMetProvider,
    );

    return CheckCategoryRequirement(
      icon: Icon(
        Icons.school_outlined,
        size: 20,
        color: theme.colorScheme.onSecondaryContainer,
      ),
      total: total, 
      target: target, 
      chip: AppChip(
        label: isProfessionalRequirementMet
            ? l10n.promotion_earned_professional_credit
            : l10n.promotion_not_earned_professional_credit,
        color: isProfessionalRequirementMet
            ? theme.colorScheme.success
            : theme.colorScheme.error,
      ),
    );
  }
}
