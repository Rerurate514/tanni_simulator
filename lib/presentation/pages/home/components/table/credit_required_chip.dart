import 'package:flutter/material.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';

class CreditRequiredChip extends StatelessWidget {
  const CreditRequiredChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        l10n.category_required,
        style: TextStyle(
          color: theme.colorScheme.error,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
