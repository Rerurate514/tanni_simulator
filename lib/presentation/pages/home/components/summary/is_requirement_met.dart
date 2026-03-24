import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';

class IsRequirementMet extends HookConsumerWidget {
  const IsRequirementMet({super.key, required this.isRequirementMet});

  final bool isRequirementMet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(!isRequirementMet) return SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        l10n.promotion_not_earned_credits,
        style: TextStyle(
          color: theme.colorScheme.error,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
