import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/providers/total_credit_provider.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumSummary extends HookConsumerWidget {
  const CurriculumSummary({super.key, required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final calcService = ref.read(creditCalculatorServiceProvider);
    final totalCredits = ref.watch(totalCreditProvider);
    final targetCredits = ref.watch(selectedRequirementProvider);

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
            buildProgress(
              theme,
              l10n, 
              calcService,
              totalCredits, 
              targetCredits?.totalCreditsRequired
            )
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

  Widget buildProgress(ThemeData theme, AppLocalizations l10n, CreditCalculatorService service, int totalCredits, int? targetCredits) {
    return Column(
      children: [
        Text(
          l10n.section_total_status,
          style: theme.textTheme.titleSmall,
        ),
        AppGap.xs(),
        targetCredits != null
        ? _buildRequiredCredits(theme, l10n, service, totalCredits, targetCredits)
        : _buildUnRequiredCredits(theme, l10n, service, totalCredits, 1000)
      ],
    );
  }

  Widget _buildRequiredCredits(ThemeData theme, AppLocalizations l10n, CreditCalculatorService service, int totalCredits, int targetCredits) {
    return Column(
      children: [
        Text(
            l10n.tanni_count(totalCredits, targetCredits),
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 12,
            ),
        ),
        AppGap.xs(),
        LinearPercentIndicator(
          animation: true,
          animateFromLastPercent: true,
          lineHeight: 24.0,
          animationDuration: 800,
          percent: service.calculatePercentage(totalCredits, targetCredits),
          barRadius: const Radius.circular(12),
          progressColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildUnRequiredCredits(ThemeData theme, AppLocalizations l10n, CreditCalculatorService service, int totalCredits, int targetCredits) {
    return Column(
      children: [
        Text(
          l10n.promotion_not_required_credits(totalCredits),
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 12,
          ),
        ),
        AppGap.xs(),
        LinearPercentIndicator(
          animation: true,
          animateFromLastPercent: true,
          lineHeight: 24.0,
          animationDuration: 800,
          percent: service.calculatePercentage(totalCredits, targetCredits),
          barRadius: const Radius.circular(12),
          progressColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
