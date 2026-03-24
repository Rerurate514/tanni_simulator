import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/domain/constants/app_color_scheme.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/providers/category_credits_progress_provider.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CheckProfessionalRequirement extends HookConsumerWidget {
  const CheckProfessionalRequirement({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    const notRequiredEarnCredit = 0;

    final progress = ref.watch(categoryCreditsEarnedProvider(CategoryType.professional));
    if(progress == null || progress.$2 == notRequiredEarnCredit) return SizedBox.shrink();

    final (total, target) = progress;
    final isProfessionalRequirementMet = ref.watch(isProfessionalRequirementMetProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          l10n.tanni_count(total, target),
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        AppGap.s(),
        AppChip(
          label: isProfessionalRequirementMet
          ? l10n.promotion_earned_professional_credit
          : l10n.promotion_not_earned_professional_credit,
          color: isProfessionalRequirementMet
          ? theme.colorScheme.success
          : theme.colorScheme.error, 
        )
      ],
    );
  }
}
