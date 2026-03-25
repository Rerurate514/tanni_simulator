import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';

class PromotionGateSelector extends HookConsumerWidget {
  const PromotionGateSelector({required this.requirements, super.key});
  final List<RequirementModel> requirements;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedRequirement = ref.watch(selectedRequirementProvider);

    return DropdownButtonFormField<RequirementModel>(
      isExpanded: true,
      initialValue: selectedRequirement,
      decoration: InputDecoration(
        labelText: l10n.promotion_dropdown_hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: requirements.map((requirement) {
        return DropdownMenuItem<RequirementModel>(
          value: requirement,
          child: Text(
            requirement.title,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        ref.read(selectedRequirementProvider.notifier).select(value);
      },
    );
  }
}
