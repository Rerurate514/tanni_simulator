import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/requirement/requirement_conditions_providers.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/check_requirement_status.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/is_requirement_met.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class RequirementsConditions extends HookConsumerWidget {
  const RequirementsConditions({required this.curriculum, super.key});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
  
    final selectedRequirement = ref.watch(selectedRequirementProvider);
    if (selectedRequirement == null) return const SizedBox.shrink();

    final isRequirementMet = ref.watch(
      isRequirementMetProvider(selectedRequirement),
    );
    final requirementStatus = ref.watch(
      requirementStatusProvider(selectedRequirement),
    );

    return ExpansionTile(
      title: buildExpansionTitle(l10n, theme),
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  IsRequirementMet(isRequirementMet: isRequirementMet),
                  if (!isRequirementMet) const AppGap.s(),
                  CheckRequirementStatus(requirementStatus: requirementStatus),
                ],
              ),
            ),
          )
        )
      ],
    );
  }

  Widget buildExpansionTitle(AppLocalizations l10n, ThemeData theme) {
    return Row(
      children: [
        Text(
          l10n.section_requirements,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
