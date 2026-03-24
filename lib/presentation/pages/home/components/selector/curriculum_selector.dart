import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/constants/curriculumn_type.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';

class CurriculumSelector extends StatefulHookConsumerWidget {
  const CurriculumSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurriculumPulldownMenuState();
}

class _CurriculumPulldownMenuState extends ConsumerState<CurriculumSelector> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedType = useState<CurriculumType?>(null);

    return DropdownButtonFormField<CurriculumType>(
      decoration: InputDecoration(
        labelText: l10n.home_dropdown_button_hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      initialValue: selectedType.value,
      items: CurriculumType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.label),
        );
      }).toList(),
      onChanged: (newType) async {
        if (newType == null) return;

        selectedType.value = newType;

        await ref
          .read(loadingCurriculumUsecaseProvider.notifier)
          .selectCurriculum(newType);
      },
    );
  }
}
