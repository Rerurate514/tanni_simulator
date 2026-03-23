import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanni_simulator/domain/entities/metadata.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumSummary extends StatelessWidget {
  const CurriculumSummary({super.key, required this.metadata});

  final MetadataModel metadata;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(theme, l10n),
            AppGap.s(),
            buildProgress(theme, l10n)
          ],
        ),
      ),
    );
  }

  Widget buildHeader(ThemeData theme, AppLocalizations l10n) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metadata.university,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metadata.department,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${metadata.applicableYear}${l10n.nendo}',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProgress(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.section_total_status,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        LinearPercentIndicator(
          animation: true,
          lineHeight: 24.0,
          animationDuration: 800,
          percent: 0.65, // TODO: 単位習得計算結果の格納
          center: const Text(
            '80 / 124 単位',
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 12,
              color: Colors.white
            ),
          ),
          barRadius: const Radius.circular(12),
          progressColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
