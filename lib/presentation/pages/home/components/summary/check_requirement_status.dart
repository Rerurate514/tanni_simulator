import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';

class CheckRequirementStatus extends HookConsumerWidget {
  const CheckRequirementStatus({super.key, required this.requirementStatus});
  
  final RequirementStatus requirementStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (requirementStatus == RequirementStatus.fulfilled) {
      return const SizedBox.shrink();
    }

    final labels = switch (requirementStatus) {
      RequirementStatus.bothCreditShortage => [
          l10n.promotion_not_earned_professional_credit,
          l10n.promotion_not_earned_general_credit,
        ],
      RequirementStatus.professionalCreditShortage => [
          l10n.promotion_not_earned_professional_credit,
        ],
      RequirementStatus.generalCreditShortage => [
          l10n.promotion_not_earned_general_credit,
        ],
      _ => [l10n.promotion_not_earned_credits],
    };

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: labels.map((label) => AppChip(
        label: label,
        color: theme.colorScheme.error,
        fontSize: 12,
        borderRadius: 6,
        backgroundOpacity: 0.15,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      )).toList(),
    );
  }
}
