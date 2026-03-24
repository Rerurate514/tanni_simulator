import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/requirements_conditions.dart';
import 'package:tanni_simulator/presentation/pages/home/providers/summary_progress_provider.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumSummary extends HookConsumerWidget {
  const CurriculumSummary({super.key, required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final label = ref.watch(summaryLabelProvider(context));
    final percent = ref.watch(summaryPercentageProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildHeader(theme, l10n),
            AppGap.s(),
            Text(l10n.section_total_status, style: theme.textTheme.titleSmall),
            AppGap.xs(),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            AppGap.xs(),
            LinearPercentIndicator(
              animation: true,
              animateFromLastPercent: true,
              lineHeight: 24.0,
              percent: percent,
              barRadius: const Radius.circular(12),
              progressColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              padding: EdgeInsets.zero,
            ),
            RequirementsConditions(curriculum: curriculum),
          ],
        ),
      )
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
                curriculum.metadata.university,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                curriculum.metadata.department,
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
            '${curriculum.metadata.applicableYear}${l10n.nendo}',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
