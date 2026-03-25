import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';

class IsRequirementMet extends HookConsumerWidget {
  const IsRequirementMet({required this.isRequirementMet, super.key});

  final bool isRequirementMet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(isRequirementMet) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AppChip(
      label: l10n.promotion_not_earned_credits,
      color: theme.colorScheme.error,
      borderRadius: 6,
      backgroundOpacity: 0.15,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}
